using Newtonsoft.Json.Linq;
using SharpFinn;
using System;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using Tweetinvi;

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
            var tweets = Timeline.GetUserTimeline(userID, 10);
            var jsonString = tweets.ToJson();

            //Using Json.NET to change json string to an array
            JArray parsedJson = JArray.Parse(jsonString);

            SingleTweet[] tweetArr = new SingleTweet[parsedJson.Count()];

            //If an account was returned
            if (tweets != null)
            {
                //Loop for each tweet
                for (int i = 0; i < parsedJson.Count(); i++)
                {
                   
                    //Initialise tweet object
                    //Making the json tweet an object
                    JObject tweet = JObject.Parse(parsedJson[i].ToString());
                    //Setting the user to an object to query against
                    JObject tweetuser = JObject.Parse(parsedJson[i]["user"].ToString());
                    //Setting the entity to an object to query against
                    JObject entity = JObject.Parse(parsedJson[i]["entities"].ToString());
                    //Setting the hashtags to an array to loop through
                    JArray hashtags = JArray.Parse(entity["hashtags"].ToString());

                    tweetArr[i] = new SingleTweet
                    {
                        tweetID = i,
                        Content = tweet["text"].ToString(),
                        retweets = (int)tweet["retweet_count"],
                        likes = (int)tweet["favorite_count"],
                        sentiment = sentimentInstance.GetScore(tweet["text"].ToString()).Sentiment

                    };
                

                
                    //Loop through for all the hashtags and add them to the hashtag array
                    for (int j = 0; j < hashtags.Count(); j++)
                    {
                        JObject hashtagContent = JObject.Parse(hashtags[j].ToString());
                        tweetArr[i].Hashtags.Add(hashtagContent["text"].ToString());
                    }

                    //Format the date/time for the tweet
                    tweetArr[i].PostTime = DateTime.ParseExact(tweet["created_at"].ToString(), "dd/MM/yyyy HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture);
                    

                }
            }
            
            return tweetArr;
        }
    }

}
