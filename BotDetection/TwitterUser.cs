using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BotDetection
{
    public class TwitterUser
    {
        public string ScreenName { get; set; }
        public ArrayList UserTweets { get; set; }
        public TwitterUser()
        {
            UserTweets = new ArrayList();
        }

        public string outputTweets(TwitterUser user)
        {

            string output = "Tweets by : " + user.ScreenName + "\n\n";

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
                + "Sentiment Analysis :\n"
                + "     Subjectivity : " + tweet.sentiment.Subjectivity + " with a confidence of " + tweet.sentiment.SubjectivityConfidence
                + "\n     Polarity : " + tweet.sentiment.Polarity + " with a confidence of " + tweet.sentiment.PolarityConfidence
                + "\n\n";

            }
            return output;
        }
    }
}