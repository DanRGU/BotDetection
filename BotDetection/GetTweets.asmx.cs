using Newtonsoft.Json.Linq;
using SharpFinn;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using Tweetinvi;
using Tweetinvi.Models;
using Tweetinvi.Parameters;

namespace BotDetection
{
    /// <summary>
    /// Summary description for WebService1
    /// </summary>
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class GetTweets : System.Web.Services.WebService
    {

        //Keys for Twitter API
        string oAuthConsumerKey = "yCCy7XFwIGDxOppd7JsDMkmjt";
        string oAuthConsumerSecret = "I8tLmmWblYLzRuHUSTtxaXmfHVLiKm0wGA0G8elR0SK34qor3D";
        string oAuthAccessToken = "469737894-eMYLQcqUEyglEaURFMGgfW2IKYEVVSXZxcAwGZEh";
        string oAuthAccessSecret = "C51EiVsmfGT08Auxl5wwYUkByDTsdy9sQxvXj2Mw5VJ1p";


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public Object GetTwitterDataJSON(string userID)
        {
            
                Auth.SetUserCredentials(oAuthConsumerKey, oAuthConsumerSecret, oAuthAccessToken, oAuthAccessSecret);
                var sentimentInstance = Sentiment.Instance;
                var lastTweets = Timeline.GetUserTimeline(userID, 200).ToArray();

                var allTweets = new List<ITweet>(lastTweets);
                var beforeLast = allTweets;

                while (lastTweets.Length > 0 && allTweets.Count <= 500)
                {
                    var idOfOldestTweet = lastTweets.Select(x => x.Id).Min();
                    Console.WriteLine($"Oldest Tweet Id = {idOfOldestTweet}");

                    var timelineRequestParameters = new UserTimelineParameters
                    {
                        // We ensure that we only get tweets that have been posted BEFORE the oldest tweet we received
                        MaxId = idOfOldestTweet - 1,
                        MaximumNumberOfTweetsToRetrieve = allTweets.Count > 480 ? (500 - allTweets.Count) : 200
                    };

                    lastTweets = Timeline.GetUserTimeline(userID, timelineRequestParameters).ToArray();
                    allTweets.AddRange(lastTweets);
                }
                var jsonString = allTweets.ToJson();

                //Using Json.NET to change json string to an array
                JArray parsedJson = JArray.Parse(jsonString);
                
                SingleTweet[] tweetArr = new SingleTweet[parsedJson.Count()];
            string screenName = "";
            int followers=0;
            int numTweets=0;
            DateTime created = new DateTime();

            //If an account was returned
            if (allTweets != null)
                {
                    Trace.WriteLine(allTweets);
                    //Loop for each tweet
                    for (int i = 0; i < parsedJson.Count(); i++)
                    {

                        //Initialise tweet object
                        //Making the json tweet an object
                        JObject tweet = JObject.Parse(parsedJson[i].ToString());
                        //Setting the entity to an object to query against
                        JObject entity = JObject.Parse(parsedJson[i]["entities"].ToString());
                        JObject retweet = new JObject();
                        JObject user = JObject.Parse(parsedJson[i]["user"].ToString());

                        //Setting the hashtags to an array to loop through
                        JArray hashtags = JArray.Parse(entity["hashtags"].ToString());



                        tweetArr[i] = new SingleTweet
                        {
                            tweetID = i,
                            Content = tweet["text"].ToString(),
                            retweets = (int)tweet["retweet_count"],
                            likes = (int)tweet["favorite_count"],
                            sentiment = sentimentInstance.GetScore(tweet["text"].ToString()).AverageSentimentTokens,
                            PostTime = DateTime.ParseExact(tweet["created_at"].ToString(), "dd/MM/yyyy HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture),
                        };

                    screenName = user["name"].ToString();
                    followers = (int)user["followers_count"];
                    numTweets = (int)user["statuses_count"];
                    created = DateTime.ParseExact(user["created_at"].ToString(), "dd/MM/yyyy HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture);

                        //Setting the retweeted status
                    if (parsedJson[i]["retweeted_status"].ToString().GetType() == typeof(string) && parsedJson[i]["retweeted_status"].ToString() != "")
                        {
                            retweet = JObject.Parse(parsedJson[i]["retweeted_status"].ToString());
                            tweetArr[i].RetweetTime = DateTime.ParseExact(retweet["created_at"].ToString(), "dd/MM/yyyy HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture);
                        }

                        //Loop through for all the hashtags and add them to the hashtag array
                        for (int j = 0; j < hashtags.Count(); j++)
                        {
                            JObject hashtagContent = JObject.Parse(hashtags[j].ToString());
                            tweetArr[i].Hashtags.Add(hashtagContent["text"].ToString());
                        }
                    }
                }
            User twitterUser = new User(screenName,followers,numTweets,created,tweetArr);

            return twitterUser;
            
        }
    }

}
