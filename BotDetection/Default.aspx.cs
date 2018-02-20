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

        protected void submitButton_Clicked(object sender, EventArgs e)
        {
            // Set up your credentials (https://apps.twitter.com)
            Auth.SetUserCredentials(oAuthConsumerKey, oAuthConsumerSecret, oAuthAccessToken, oAuthAccessSecret);

            var tweets = Timeline.GetUserTimeline(userInput.Text,6);
            var jsonString = Tweetinvi.JsonSerializer.ToJson(tweets);
            //Using Json.NET to change json string to an array
            JArray parsedJson = JArray.Parse(jsonString);
            string tweettext = "";

            if (tweets != null)
            {
                for (int x = 0; x < parsedJson.Count(); x++)
                {
                    JObject tweet = JObject.Parse(parsedJson[x].ToString());

                    
                    tweettext += tweet["text"].ToString() + "\n on " + tweet["created_at"].ToString() + "\n\n";
                    
                    
                }

                twitterOutput.Text = tweettext;
            }
            else {
                twitterOutput.Text = "Private Account";
            }
        }
    }

    //https://stackoverflow.com/questions/12511171/deserialize-twitter-json-with-json-net-in-c-sharp-to-fetch-hashtags

    public class TwitterUser
    {

        public string ScreenName { get; set; }
        public Tweets Tweets{ get; set; }
        public string PostTime { get; set; }
        public Array Hashtags { get; set; }

    }

    public class Tweets {

        public string Content { get; set; }
        

    }
}