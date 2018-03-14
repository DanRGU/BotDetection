using Aylien.TextApi;
using System;
using System.Collections;

namespace BotDetection
{
    public class SingleTweet
    {
        public string Content { get; set; }
        public DateTime PostTime { get; set; }
        public int retweets { get; set; }
        public int likes { get; set; }
        public ArrayList Hashtags { get; set; }
        public Sentiment sentiment { get; set; }
        public int tweetID { get; set; }

        public SingleTweet()
        {
            Content = "";
            Hashtags = new ArrayList();
            PostTime = new DateTime();
            sentiment = null;
            retweets = 0;
            likes = 0;
            tweetID = 0;
        }
    }
}