using System;
using System.Collections;
using static SharpFinn.Sentiment;

namespace BotDetection
{
    public class SingleTweet
    {
        public string Content { get; set; }
        public DateTime PostTime { get; set; }
        public int retweets { get; set; }
        public int likes { get; set; }
        public ArrayList Hashtags { get; set; }
        public int sentiment { get; set; }
        public int tweetID { get; set; }

        public SingleTweet()
        {
            Content = "";
            Hashtags = new ArrayList();
            PostTime = new DateTime();
            sentiment = 0;
            retweets = 0;
            likes = 0;
            tweetID = 0;
        }
    }
}