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
            // Set up your credentials (https://apps.twitter.com)
            Auth.SetUserCredentials(oAuthConsumerKey, oAuthConsumerSecret, oAuthAccessToken, oAuthAccessSecret);
            
           
            var tweets = Timeline.GetUserTimeline(userInput.Text, 6);
            

            var jsonString = Tweetinvi.JsonSerializer.ToJson(tweets);
            //Using Json.NET to change json string to an array
            JArray parsedJson = JArray.Parse(jsonString);

            string tweettext = "";
            int numHashtags = 0;

            if (tweets != null)
            {
                //Loop for each tweet
                for (int x = 0; x < parsedJson.Count(); x++)
                {
                    ArrayList hashtagList = new ArrayList();

                    JObject tweet = JObject.Parse(parsedJson[x].ToString());
                   // JObject tweet2 = JObject.Parse(parsedJson[x+1].ToString());


                    JObject entity = JObject.Parse(parsedJson[x]["entities"].ToString());
                    JArray hashtags = JArray.Parse(entity["hashtags"].ToString());

                    for (int i = 0; i < hashtags.Count(); i++)
                    {
                        JObject hashtagContent = JObject.Parse(hashtags[i].ToString());
                        hashtagList.Add(hashtagContent["text"].ToString());
                    }

                    numHashtags = hashtagList.Count;
                   // DateTime myDate = DateTime.ParseExact(tweet["created_at"].ToString(), "dd/mm/yyyy HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture);

                    tweettext += tweet["text"].ToString() + 
                        "\n Tweet length :" + tweet["text"].ToString().Length +
                        "\n" + "Containing "+ numHashtags +  " hashtags \n" +
                        "Time since last tweet " + tweet["created_at"].ToString() + "\n\n";
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