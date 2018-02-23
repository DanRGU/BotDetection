using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;
using System.Text;
using Tweetinvi;
using Newtonsoft.Json.Linq;
using System.Collections;

namespace BotDetection
{
    public partial class _Default : Page
    {
        string oAuthConsumerKey = "yCCy7XFwIGDxOppd7JsDMkmjt";
        string oAuthConsumerSecret = "I8tLmmWblYLzRuHUSTtxaXmfHVLiKm0wGA0G8elR0SK34qor3D";
        string oAuthAccessToken = "469737894-eMYLQcqUEyglEaURFMGgfW2IKYEVVSXZxcAwGZEh";
        string oAuthAccessSecret = "C51EiVsmfGT08Auxl5wwYUkByDTsdy9sQxvXj2Mw5VJ1p";


        protected void Page_Load(object sender, EventArgs e)
        {

        }

        //Using TweetInvi to gather the Twitter timeline of the supplied account
        //https://github.com/linvi/tweetinvi/wiki/Introduction

        /*
         Questions

        JSON to c# objects or keep as json (current method)
        Store stuff in DB before (long JSON string)?  or filter down and store like that


         */

        protected void submitButton_Clicked(object sender, EventArgs e)
        {
            twitterOutput.Text = "";
            // Set up your credentials (https://apps.twitter.com)
            Auth.SetUserCredentials(oAuthConsumerKey, oAuthConsumerSecret, oAuthAccessToken, oAuthAccessSecret);

            TwitterUser user = new TwitterUser();

            var tweets = Timeline.GetUserTimeline(userInput.Text,10);
            var jsonString = Tweetinvi.JsonSerializer.ToJson(tweets);
            //Using Json.NET to change json string to an array
            JArray parsedJson = JArray.Parse(jsonString);


            if (tweets != null)
            {
                //Loop for each tweet
                for (int x = 0; x < parsedJson.Count(); x++)
                {
                    SingleTweet tweet1 = new SingleTweet();

                    JObject tweet = JObject.Parse(parsedJson[x].ToString());

                    JObject tweetuser = JObject.Parse(parsedJson[x]["user"].ToString());
                    JObject entity = JObject.Parse(parsedJson[x]["entities"].ToString());

                    JArray hashtags = JArray.Parse(entity["hashtags"].ToString());

                    tweet1.Content = tweet["text"].ToString();
                    tweet1.retweets = (int)tweet["retweet_count"];
                    tweet1.likes = (int)tweet["favorite_count"];

                    for (int i = 0; i < hashtags.Count(); i++)
                    {
                        JObject hashtagContent = JObject.Parse(hashtags[i].ToString());
                        tweet1.Hashtags.Add(hashtagContent["text"].ToString());
                    }


                    tweet1.PostTime = DateTime.ParseExact(tweet["created_at"].ToString(), "dd/MM/yyyy HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture);
                    //Setting the user stuff
                    user.ScreenName = tweetuser["name"].ToString();
                    user.UserTweets.Add(tweet1);
                }

            }

            else
            {
                twitterOutput.Text = "Private Account";
            }

            twitterOutput.Text = "Tweets by : " + user.ScreenName + "\n";

            for (int i = 0; i < user.UserTweets.Count; i++)
            {
                SingleTweet tweet = (SingleTweet)user.UserTweets[i];//Setting current tweet
                SingleTweet tweet2 = new SingleTweet();//Initialising previous tweet (next in array)
                TimeSpan span = new TimeSpan(); //Initialising TimeSpan

                if (i + 1 < user.UserTweets.Count)
                {
                    tweet2 = (SingleTweet)user.UserTweets[i + 1];
                    span = (tweet.PostTime - tweet2.PostTime);
                }

                //Outputting tweet Information
                twitterOutput.Text += tweet.Content + "\n";
                twitterOutput.Text += "Containing " + tweet.Hashtags.Count + " hashtags\n";
                twitterOutput.Text += tweet.Content.Length + " characters long\n";
                twitterOutput.Text += "Time of post " + tweet.PostTime + "\n";
                twitterOutput.Text += "Time since previous post " + span.Days + " days, " + span.Hours + " hours, " + span.Minutes + " minutes, " + span.Seconds + " seconds" + "\n";
                twitterOutput.Text += "Number of retweets " + tweet.retweets + "\n";
                twitterOutput.Text += "Number of likes " + tweet.likes + "\n";
                twitterOutput.Text += "\n\n";

            }
        }
    }

    //https://stackoverflow.com/questions/12511171/deserialize-twitter-json-with-json-net-in-c-sharp-to-fetch-hashtags

    /*
     TASK LIST
     *Create classes for a user
     *Create class for a tweet
     */

    public class TwitterUser
    {
        public string ScreenName { get; set; }
        public ArrayList UserTweets { get; set; }
        public TwitterUser()
        {
            UserTweets = new ArrayList();
        }
    }

    public class SingleTweet
    {

        public string Content { get; set; }
        public DateTime PostTime { get; set; }
        public int retweets { get; set; }
        public int likes { get; set; }
        public ArrayList Hashtags { get; set; }

        public SingleTweet()
        {
            Hashtags = new ArrayList();
            PostTime = new DateTime();
            retweets = 0;
            likes = 0;
        }

    }
}