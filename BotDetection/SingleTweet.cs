using Aylien.TextApi;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;

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

        public SingleTweet()
        {
            Hashtags = new ArrayList();
            PostTime = new DateTime();
            retweets = 0;
            likes = 0;
        }
    }
}