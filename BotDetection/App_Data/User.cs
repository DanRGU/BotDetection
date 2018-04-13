using System;
using System.Collections;
using static SharpFinn.Sentiment;

namespace BotDetection
{
    public class User
    {
        public string screenName { get; set; }
        public string userName{ get; set; }
        public int followers { get; set; }
        public DateTime created { get; set; }
        public int numTweets { get; set; }
        public SingleTweet[] tweets { get; set; }

        public User(string userName, string screenName,int followers, int numTweets, DateTime created,SingleTweet[] tweetarray)
        {
            this.userName = userName;
            this.screenName = screenName;
            this.followers = followers;
            this.created = created;
            this.numTweets = numTweets;
            this.tweets = tweetarray;

        }
    }
}