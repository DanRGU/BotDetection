using System;
using System.Linq;
using System.Web.UI;
using Tweetinvi;
using Newtonsoft.Json.Linq;
using System.Collections;
using Aylien.TextApi;

namespace BotDetection
{
    public partial class _Default : Page
    {
        string oAuthConsumerKey = "yCCy7XFwIGDxOppd7JsDMkmjt";
        string oAuthConsumerSecret = "I8tLmmWblYLzRuHUSTtxaXmfHVLiKm0wGA0G8elR0SK34qor3D";
        string oAuthAccessToken = "469737894-eMYLQcqUEyglEaURFMGgfW2IKYEVVSXZxcAwGZEh";
        string oAuthAccessSecret = "C51EiVsmfGT08Auxl5wwYUkByDTsdy9sQxvXj2Mw5VJ1p";
        public string charsInTweets = "[";

        Client client = new Client("48a217c2", "000e2e66dcac9d404baf101d3d6dcac9");

        protected void Page_Load(object sender, EventArgs e)
        {
        // Set up credentials (https://apps.twitter.com)
        Auth.SetUserCredentials(oAuthConsumerKey, oAuthConsumerSecret, oAuthAccessToken, oAuthAccessSecret);
        }

        //Using TweetInvi to gather the Twitter timeline of the supplied account
        //https://github.com/linvi/tweetinvi/wiki/Introduction

        protected void submitButton_Clicked(object sender, EventArgs e)
        {
            twitterOutput.Text = "";
            

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

                    SingleTweet currentTweet = new SingleTweet();

                    JObject tweet = JObject.Parse(parsedJson[x].ToString());

                    JObject tweetuser = JObject.Parse(parsedJson[x]["user"].ToString());
                    JObject entity = JObject.Parse(parsedJson[x]["entities"].ToString());

                    JArray hashtags = JArray.Parse(entity["hashtags"].ToString());
                    
                    currentTweet.Content = tweet["text"].ToString();
                    currentTweet.retweets = (int)tweet["retweet_count"];
                    currentTweet.likes = (int)tweet["favorite_count"];
                    currentTweet.sentiment = client.Sentiment(  text:tweet["text"].ToString());
                    
                    for (int i = 0; i < hashtags.Count(); i++)
                    {
                        JObject hashtagContent = JObject.Parse(hashtags[i].ToString());
                        currentTweet.Hashtags.Add(hashtagContent["text"].ToString());
                    }


                    currentTweet.PostTime = DateTime.ParseExact(tweet["created_at"].ToString(), "dd/MM/yyyy HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture);
                    //Setting the user stuff
                    user.ScreenName = tweetuser["name"].ToString();
                    user.UserTweets.Add(currentTweet);
                    charsInTweets += currentTweet.Content.Length + ",";

                }
                charsInTweets += "]";
            }
            else
            {
                twitterOutput.Text = "Private Account";
            }

            twitterOutput.Text = user.outputTweets(user);
            
        }
    }

    // Use web sockets to update js
    //tweet sentiment analysis affin


    //https://stackoverflow.com/questions/12511171/deserialize-twitter-json-with-json-net-in-c-sharp-to-fetch-hashtags


    public class TwitterUser
    {
        public string ScreenName { get; set; }
        public ArrayList UserTweets { get; set; }
        public TwitterUser()
        {
            UserTweets = new ArrayList();
        }

        public string outputTweets(TwitterUser user) {

            string output = "Tweets by : " + user.ScreenName + "\n";

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
                output += tweet.Content + "\n" + "Containing " + tweet.Hashtags.Count + " hashtags\n"
                + tweet.Content.Length + " characters long\n"
                + "Time of post " + tweet.PostTime + "\n"
                + "Time since previous post " + span.Days + " days, " + span.Hours + " hours, " + span.Minutes + " minutes, " + span.Seconds + " seconds" + "\n"
                + "Number of retweets " + tweet.retweets + "\n"
                + "Number of likes " + tweet.likes + "\n"
                + " Sentiment Analysis :\n" 
                + "     Subjectivity : " + tweet.sentiment.Subjectivity + " with a confidence of " + tweet.sentiment.SubjectivityConfidence
                + "\n     Polarity : " + tweet.sentiment.Polarity + " with a confidence of " + tweet.sentiment.PolarityConfidence
                + "\n\n";

            }
            return output;
        }
    }

    public class SingleTweet
    {

        public string Content { get; set; }
        public DateTime PostTime { get; set; }
        public int retweets { get; set; }
        public int likes { get; set; }
        public ArrayList Hashtags { get; set; }
         public Sentiment sentiment { get; set; }

        public SingleTweet()
        {
            Hashtags = new ArrayList();
            PostTime = new DateTime();
            retweets = 0;
            likes = 0;
        }

    }
}