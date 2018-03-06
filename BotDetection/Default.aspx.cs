using System;
using System.Linq;
using System.Web.UI;
using Tweetinvi;
using Newtonsoft.Json.Linq;
using System.Collections;
using Aylien.TextApi;
using System.Web.UI.WebControls;

namespace BotDetection
{
    public partial class _Default : Page
    {

        //Keys for Twitter API
        string oAuthConsumerKey = "yCCy7XFwIGDxOppd7JsDMkmjt";
        string oAuthConsumerSecret = "I8tLmmWblYLzRuHUSTtxaXmfHVLiKm0wGA0G8elR0SK34qor3D";
        string oAuthAccessToken = "469737894-eMYLQcqUEyglEaURFMGgfW2IKYEVVSXZxcAwGZEh";
        string oAuthAccessSecret = "C51EiVsmfGT08Auxl5wwYUkByDTsdy9sQxvXj2Mw5VJ1p";
        //Keys for Sentiment c# SDK
        Client client = new Client("48a217c2", "000e2e66dcac9d404baf101d3d6dcac9");
        public string tweetLengths = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Set up credentials (https://apps.twitter.com)
            //Should i make the user authenticate themself?

        }

        //Initialising User Object
        public TwitterUser user = new TwitterUser();

        //Using TweetInvi to gather the Twitter timeline of the supplied account
        //https://github.com/linvi/tweetinvi/wiki/Introduction

        //http://www.c-sharpcorner.com/UploadFile/dacca2/understand-jquery-ajax-function-call-code-behind-C-Sharp-method/
        public string submitButton_Clicked()
        {
            Auth.SetUserCredentials(oAuthConsumerKey, oAuthConsumerSecret, oAuthAccessToken, oAuthAccessSecret);
            //Set the output box to empty
            twitterOutput.Text = "";


            var tweets = Timeline.GetUserTimeline(userInput.Text, 10);
            var jsonString = Tweetinvi.JsonSerializer.ToJson(tweets);
            //Using Json.NET to change json string to an array
            JArray parsedJson = JArray.Parse(jsonString);

            //If an account was returned
            if (tweets != null)
            {
                tweetLengths = "[";
                //Loop for each tweet
                for (int x = 0; x < parsedJson.Count(); x++)
                {
                    //Initialise tweet object
                    SingleTweet currentTweet = new SingleTweet();

                    //Making the json tweet an object
                    JObject tweet = JObject.Parse(parsedJson[x].ToString());

                    //Setting the user to an object to query against
                    JObject tweetuser = JObject.Parse(parsedJson[x]["user"].ToString());
                    //Setting the entity to an object to query against
                    JObject entity = JObject.Parse(parsedJson[x]["entities"].ToString());

                    //Setting the hashtags to an array to loop through
                    JArray hashtags = JArray.Parse(entity["hashtags"].ToString());

                    //Setting the tweet variables
                    currentTweet.Content = tweet["text"].ToString();
                    currentTweet.retweets = (int)tweet["retweet_count"];
                    currentTweet.likes = (int)tweet["favorite_count"];
                    //Setting sentiment for tweet content
                    currentTweet.sentiment = client.Sentiment(text: tweet["text"].ToString());
                    tweetLengths += tweet["text"].ToString().Length + ",";


                    //Loop through for all the hashtags and add them to the hashtag array
                    for (int i = 0; i < hashtags.Count(); i++)
                    {
                        JObject hashtagContent = JObject.Parse(hashtags[i].ToString());
                        currentTweet.Hashtags.Add(hashtagContent["text"].ToString());
                    }

                    //Format the date/time for the tweet
                    currentTweet.PostTime = DateTime.ParseExact(tweet["created_at"].ToString(), "dd/MM/yyyy HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture);

                    //Setting the user stuff
                    user.ScreenName = tweetuser["name"].ToString();
                    user.UserTweets.Add(currentTweet);

                }
                tweetLengths += "]";
                userInput.Text = "";

            }
            else
            {
                twitterOutput.Text = "Private Account";
            }
            return user.outputTweets(user);
        }
    }

    // Use web sockets to update js
    //tweet sentiment analysis affin


    //https://stackoverflow.com/questions/12511171/deserialize-twitter-json-with-json-net-in-c-sharp-to-fetch-hashtags



}