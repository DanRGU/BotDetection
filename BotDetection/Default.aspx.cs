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
using Newtonsoft.Json;

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

            var tweets = Timeline.GetUserTimeline(userInput.Text,1);
            var json = Tweetinvi.JsonSerializer.ToJson(tweets);


            if (tweets != null)
            {
                foreach (var tweet in tweets)
                {
                    twitterOutput.Text = json.ToString();
                    break;
                }
            }
            else {
                twitterOutput.Text = "Private Account";
            }
        }
    }

    public class TwitterUser
    {

        public string ScreenName { get; set; }
        public Tweets tweets{ get; set; }
        public string postTime { get; set; }
        public Array hashtags { get; set; }

    }

    public class Tweets {

        public string content { get; set; }
        

    }
}