using System;
using System.Collections;
using static SharpFinn.Sentiment;

namespace BotDetection
{
    public class SingleTweet
    {
        public string Content { get; set; }
        public DateTime PostTime { get; set; }
        public DateTime RetweetTime { get; set; }
        public int retweets { get; set; }
        public int likes { get; set; }
        public ArrayList Hashtags { get; set; }
        public double sentiment { get; set; }
        public int tweetID { get; set; }
        public string screenName { get; set; }
        public int followers { get; set; }
        public DateTime created { get; set; }
        public int numTweets { get; set; }

        public SingleTweet()
        {
            Content = "";
            Hashtags = new ArrayList();
            PostTime = new DateTime();
            RetweetTime = new DateTime();
            sentiment = 0.0;
            retweets = 0;
            likes = 0;
            tweetID = 0;
            screenName = "";
            followers = 0;
            created = new DateTime();
            numTweets = 0;

        }
    }
}