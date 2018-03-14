<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BotDetection._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">

        function parseDate(input) {
            var date = new Date(input);
            var output = date.getHours() + " hour(s), " + date.getMinutes() + " minute(s), " + date.getSeconds() + "second(s)";
            return output;
        }

        //https://www.trulia.com/vis/tru247/ Mapping times for posting
        //https://bl.ocks.org/mbostock/c69f5960c6b1a95b6f78
        //http://bl.ocks.org/bunkat/2595950

        function getData() {

            var dataParam = $("#userInput").val();

            $.ajax({
                url: "GetTweets.asmx/GetTwitterDataJSON",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{ 'userID': '" + dataParam + "' }",
                success:

                function (response) {

                    //Setting tweets to the JSON objects under d
                    var tweets = response.d;

                    //Initialising the variables for the tweets
                    var content = [];
                    var retweets = [];
                    var likes = [];
                    var dates = [];
                    var tweetLengths = [];
                    var timeSince = [];
                    var subjectivity = [];
                    var polarity = [];
                    var subjectivityConfidence = [];
                    var polarityConfidence = [];

                    ///stuf.push({ content: content , })

                    //Looping for each tweet and adding the variables to the arrays
                    for (var i in tweets) {

                        var tweet = tweets[i];
                        var tweetSentiment = tweets[i].sentiment;

                        //Tweet stuff
                        content.push(tweet["Content"]);
                        dates.push(new Date(parseFloat(tweet["PostTime"].substr(6))));
                        tweetLengths.push(content[i].length);
                        retweets.push(tweet["retweets"]);
                        likes.push(tweet["likes"]);

                        //Sentiment Stuff
                        subjectivity.push(tweetSentiment["Subjectivity"]);
                        polarity.push(tweetSentiment["Polarity"]);
                        subjectivityConfidence.push(tweetSentiment["SubjectivityConfidence"]);
                        polarityConfidence.push(tweetSentiment["PolarityConfidence"]);

                    }

                    for (var i = 0; i < tweets.length; i++) {
                        if (i < tweets.length - 1) {
                            timeSince.push(new Date(dates[i].getTime() - dates[i + 1].getTime()));
                        }
                        else {
                            timeSince.push(0);
                        }

                        $("#twitterOutput").append(
                            content[i]
                            + "\nLength: "
                            + tweetLengths[i]
                            + "\nOn " + dates[i].toUTCString()
                            + "\n"
                            + "Time since last post " + parseDate(timeSince[i])
                            + "\n"
                            + "Tweet Analysis\n"
                            + "\t Subjectivity : " + subjectivity[i] + " with a confidence of : " + subjectivityConfidence[i] + "\n\tPolarity : " + polarity[i] + " with a confidence of : " + polarityConfidence[i]
                            + "\n\n");

                    }

                    d3.select(".chart")
                        .selectAll("div")
                        .data(tweetLengths)
                        .enter()
                        .append("div")
                        .style("width", function (d) { return d * 2 + "px"; })
                        .text(function (d) { return d; });



                    var data = [[5, 3], [10, 17], [15, 4], [2, 8]];

                    var margin = { top: 20, right: 15, bottom: 60, left: 60 }
                        , width = 960 - margin.left - margin.right
                        , height = 500 - margin.top - margin.bottom;

                    var x = d3.scale.linear()
                        .domain([0, d3.max(data, function (d) { return d[0]; })])
                        .range([0, width]);

                    var y = d3.scale.linear()
                        .domain([0, d3.max(data, function (d) { return d[1]; })])
                        .range([height, 0]);

                    var chart = d3.select('body')
                        .append('svg:svg')
                        .attr('width', width + margin.right + margin.left)
                        .attr('height', height + margin.top + margin.bottom)
                        .attr('class', 'chart')

                    var main = chart.append('g')
                        .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
                        .attr('width', width)
                        .attr('height', height)
                        .attr('class', 'main')

                    // draw the x axis
                    var xAxis = d3.svg.axis()
                        .scale(x)
                        .orient('bottom');

                    main.append('g')
                        .attr('transform', 'translate(0,' + height + ')')
                        .attr('class', 'main axis date')
                        .call(xAxis);

                    // draw the y axis
                    var yAxis = d3.svg.axis()
                        .scale(y)
                        .orient('left');

                    main.append('g')
                        .attr('transform', 'translate(0,0)')
                        .attr('class', 'main axis date')
                        .call(yAxis);

                    var g = main.append("svg:g");

                    g.selectAll("scatter-dots")
                        .data(data)
                        .enter().append("svg:circle")
                        .attr("cx", function (d, i) { return x(d[0]); })
                        .attr("cy", function (d) { return y(d[1]); })
                        .attr("r", 8);

                }
            });
        }

    </script>

    <div id="inputContainer">

        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <div id="submission">
                    <input id="userInput" />
                    <button id="userSubmit" onclick="getData()"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
                </div>

                <textarea id="twitterOutput"></textarea>
            </ContentTemplate>
        </asp:UpdatePanel>

        <div class="chart">
            <h4>Tweet Lengths</h4>
        </div>
        <div class="scatterChart">
        </div>

    </div>
</asp:Content>
