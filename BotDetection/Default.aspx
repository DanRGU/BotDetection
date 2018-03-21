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
                    console.log("working2");
                    //Setting tweets to the JSON objects under d
                    var tweets = response.d;
                    
                    //test
                    //Initialising the variables for the tweets
                    var content = [];
                    var retweets = [];
                    var likes = [];
                    var dates = [];
                    var tweetLengths = [];
                    var timeSince = [];
                    var sentimentScore = [];
                    var scatterData = [];
                    var heatData = [
                        { day: 1, hour: 1, value: 220},
                        { day: 1, hour: 2, value: 0},
                        { day: 1, hour: 3, value: 2},
                        { day: 1, hour: 4, value: 10 },
                        { day: 1, hour: 5, value: 22 },
                        { day: 1, hour: 6, value: 13 },
                        { day: 1, hour: 7, value: 65 },
                        { day: 1, hour: 8, value: 100 },
                        { day: 1, hour: 9, value: 65 },
                        { day: 1, hour: 10, value: 54 },
                        { day: 1, hour: 11, value: 32 },
                        { day: 1, hour: 12, value: 68 },
                        { day: 1, hour: 13, value: 20 },
                        { day: 1, hour: 14, value: 87 },
                        { day: 1, hour: 15, value: 23 },
                        { day: 1, hour: 16, value: 26 },
                        { day: 1, hour: 17, value: 27 },
                        { day: 1, hour: 18, value: 29 },
                        { day: 1, hour: 19, value: 20 },
                        { day: 1, hour: 21, value: 22 },
                        { day: 1, hour: 20, value: 74 },
                        { day: 1, hour: 22, value: 11 },
                        { day: 1, hour: 23, value: 16 },
                        { day: 1, hour: 24, value: 1 },
                        { day: 2, hour: 1, value: 220 },
                        { day: 2, hour: 2, value: 20 },
                        { day: 2, hour: 3, value: 20 },
                        { day: 2, hour: 4, value: 20 },
                        { day: 2, hour: 5, value: 20 },
                        { day: 2, hour: 6, value: 20 },
                        { day: 2, hour: 7, value: 20 },
                        { day: 2, hour: 8, value: 20 },
                        { day: 2, hour: 9, value: 20 },
                        { day: 2, hour: 10, value: 20 },
                        { day: 2, hour: 11, value: 20 },
                        { day: 2, hour: 12, value: 20 },
                        { day: 2, hour: 13, value: 20 },
                        { day: 2, hour: 14, value: 20 },
                        { day: 2, hour: 15, value: 20 },
                        { day: 2, hour: 16, value: 20 },
                        { day: 2, hour: 17, value: 20 },
                        { day: 2, hour: 18, value: 20 },
                        { day: 2, hour: 19, value: 20 },
                        { day: 2, hour: 20, value: 74 },
                        { day: 2, hour: 21, value: 20 },
                        { day: 2, hour: 22, value: 20 },
                        { day: 2, hour: 23, value: 20 },
                        { day: 2, hour: 24, value: 20 },
                        { day: 3, hour: 1, value: 220 },
                        { day: 3, hour: 2, value: 20 },
                        { day: 3, hour: 3, value: 20 },
                        { day: 3, hour: 4, value: 20 },
                        { day: 3, hour: 5, value: 20 },
                        { day: 3, hour: 6, value: 20 },
                        { day: 3, hour: 7, value: 20 },
                        { day: 3, hour: 8, value: 20 },
                        { day: 3, hour: 9, value: 20 },
                        { day: 3, hour: 10, value: 20 },
                        { day: 3, hour: 11, value: 20 },
                        { day: 3, hour: 12, value: 20 },
                        { day: 3, hour: 13, value: 20 },
                        { day: 3, hour: 14, value: 20 },
                        { day: 3, hour: 15, value: 20 },
                        { day: 3, hour: 16, value: 20 },
                        { day: 3, hour: 17, value: 20 },
                        { day: 3, hour: 18, value: 20 },
                        { day: 3, hour: 19, value: 20 },
                        { day: 3, hour: 20, value: 74 },
                        { day: 3, hour: 21, value: 20 },
                        { day: 3, hour: 22, value: 20 },
                        { day: 3, hour: 23, value: 20 },
                        { day: 3, hour: 24, value: 20 },
                        { day: 4, hour: 1, value: 220 },
                        { day: 4, hour: 2, value: 20 },
                        { day: 4, hour: 3, value: 20 },
                        { day: 4, hour: 4, value: 20 },
                        { day: 4, hour: 5, value: 20 },
                        { day: 4, hour: 6, value: 20 },
                        { day: 4, hour: 7, value: 20 },
                        { day: 4, hour: 8, value: 20 },
                        { day: 4, hour: 9, value: 20 },
                        { day: 4, hour: 10, value: 20 },
                        { day: 4, hour: 11, value: 20 },
                        { day: 4, hour: 12, value: 20 },
                        { day: 4, hour: 13, value: 20 },
                        { day: 4, hour: 14, value: 20 },
                        { day: 4, hour: 15, value: 20 },
                        { day: 4, hour: 16, value: 20 },
                        { day: 4, hour: 17, value: 20 },
                        { day: 4, hour: 18, value: 20 },
                        { day: 4, hour: 19, value: 20 },
                        { day: 4, hour: 20, value: 74 },
                        { day: 4, hour: 21, value: 20 },
                        { day: 4, hour: 22, value: 20 },
                        { day: 4, hour: 23, value: 20 },
                        { day: 4, hour: 24, value: 20 },
                        { day: 5, hour: 1, value: 220 },
                        { day: 5, hour: 2, value: 20 },
                        { day: 5, hour: 3, value: 20 },
                        { day: 5, hour: 4, value: 20 },
                        { day: 5, hour: 5, value: 20 },
                        { day: 5, hour: 6, value: 20 },
                        { day: 5, hour: 7, value: 20 },
                        { day: 5, hour: 8, value: 20 },
                        { day: 5, hour: 9, value: 20 },
                        { day: 5, hour: 10, value: 20 },
                        { day: 5, hour: 11, value: 20 },
                        { day: 5, hour: 12, value: 20 },
                        { day: 5, hour: 13, value: 20 },
                        { day: 5, hour: 14, value: 20 },
                        { day: 5, hour: 15, value: 20 },
                        { day: 5, hour: 16, value: 20 },
                        { day: 5, hour: 17, value: 20 },
                        { day: 5, hour: 18, value: 20 },
                        { day: 5, hour: 19, value: 20 },
                        { day: 5, hour: 20, value: 74 },
                        { day: 5, hour: 21, value: 20 },
                        { day: 5, hour: 22, value: 20 },
                        { day: 5, hour: 23, value: 20 },
                        { day: 5, hour: 24, value: 20 },
                        { day: 6, hour: 1, value: 220 },
                        { day: 6, hour: 2, value: 20 },
                        { day: 6, hour: 3, value: 20 },
                        { day: 6, hour: 4, value: 20 },
                        { day: 6, hour: 5, value: 20 },
                        { day: 6, hour: 6, value: 20 },
                        { day: 6, hour: 7, value: 20 },
                        { day: 6, hour: 8, value: 0 },
                        { day: 6, hour: 9, value: 20 },
                        { day: 6, hour: 10, value: 20 },
                        { day: 6, hour: 11, value: 20 },
                        { day: 6, hour: 12, value: 20 },
                        { day: 6, hour: 13, value: 20 },
                        { day: 6, hour: 14, value: 20 },
                        { day: 6, hour: 15, value: 20 },
                        { day: 6, hour: 16, value: 20 },
                        { day: 6, hour: 17, value: 20 },
                        { day: 6, hour: 18, value: 20 },
                        { day: 6, hour: 19, value: 20 },
                        { day: 6, hour: 20, value: 75},
                        { day: 6, hour: 21, value: 64 },
                        { day: 6, hour: 22, value: 54 },
                        { day: 6, hour: 23, value: 34 },
                        { day: 6, hour: 24, value: 2 },
                        { day: 7, hour: 1, value: 220 },
                        { day: 7, hour: 2, value: 5 },
                        { day: 7, hour: 3, value: 60 },
                        { day: 7, hour: 4, value: 80 },
                        { day: 7, hour: 5, value: 70 },
                        { day: 7, hour: 6, value: 60 },
                        { day: 7, hour: 7, value: 50 },
                        { day: 7, hour: 8, value: 40 },
                        { day: 7, hour: 9, value: 30 },
                        { day: 7, hour: 10, value: 20 },
                        { day: 7, hour: 11, value: 89 },
                        { day: 7, hour: 12, value: 98 },
                        { day: 7, hour: 13, value: 3 },
                        { day: 7, hour: 14, value: 2 },
                        { day: 7, hour: 15, value: 3 },
                        { day: 7, hour: 16, value: 20 },
                        { day: 7, hour: 17, value: 211 },
                        { day: 7, hour: 18, value: 1 },
                        { day: 7, hour: 19, value: 243 },
                        { day: 7, hour: 20, value: 74 },
                        { day: 7, hour: 21, value: 54 },
                        { day: 7, hour: 22, value: 120 },
                        { day: 7, hour: 23, value: 233 },
                        { day: 7, hour: 24, value: 22 },

                    ];


                    console.log("working 1");
                    //Looping for each tweet and adding the variables to the arrays
                    for (var i in tweets) {

                        var tweet = tweets[i];

                        //Tweet stuff
                        content.push(tweet["Content"]);
                        dates.push(new Date(parseFloat(tweet["PostTime"].substr(6))));
                        tweetLengths.push(content[i].length);
                        retweets.push(tweet["retweets"]);
                        likes.push(tweet["likes"]);
                        sentimentScore.push(tweet["sentiment"]);
                        

                    }
                    console.log("working");

                    //Printing to output
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
                            + "Sentiment Score : " + sentimentScore[i]
                            + "\n\n");

                    }

                    //Drawing the bar chart
                    drawBarChart(tweetLengths);
                    //drawScatterChart(scatterData);
                    drawHeatmapChart(heatData);
                }


            });
        }

        function drawBarChart(data) {
            d3.select(".barChart")
                .selectAll("div")
                .data(data)
                .enter()
                .append("div")
                .style("width", function (d) { return d * 2 + "px"; })
                .text(function (d) { return d; });
        }

        function drawScatterChart(data) {

            //drawing the scatter graph (issues with the Y axis numbering)
            //setting margins
            var margin = { top: 20, right: 15, bottom: 60, left: 60 }
                , width = 500 - margin.top - margin.bottom
                , height = 500 - margin.top - margin.bottom;

            //
            var x = d3.scale.linear()
                .domain([-1, 1])
                .range([0, width]);

            var y = d3.scale.linear()
                .domain([-1, 1])
                .range([height, 0]);

            var chart = d3.select('.scatterChart')
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
                .attr("r", 2);

            chart.selectAll(".tick")
                .each(function (d, i) {
                    if (d != 1) {
                        this.remove();
                    }

                });
            chart.selectAll("text")
                .each(function (d, i) {
                    if (d != 1 && d != -1) {
                        this.remove();
                    }

                });
        }

        function drawHeatmapChart(data) {

            //using http://bl.ocks.org/tjdecke/5558084

            var margin = { top: 50, right: 0, bottom: 100, left: 30 },
                width = 960 - margin.left - margin.right,
                height = 430 - margin.top - margin.bottom,
                gridSize = Math.floor(width / 24),
                legendElementWidth = gridSize * 2,
                buckets = 9,
                colors = ["#ffffd9", "#edf8b1", "#c7e9b4", "#7fcdbb", "#41b6c4", "#1d91c0", "#225ea8", "#253494", "#081d58"], // alternatively colorbrewer.YlGnBu[9]
                days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"],
                times = ["1am", "2am", "3am", "4am", "5am", "6am", "7am", "8am", "9am", "10am", "11am", "12am", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm", "9pm", "10pm", "11pm", "12pm"];


            var svg = d3.select(".heatMap").append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

            var dayLabels = svg.selectAll(".dayLabel")
                .data(days)
                .enter().append("text")
                .text(function (d) { return d; })
                .attr("x", 0)
                .attr("y", function (d, i) { return i * gridSize; })
                .style("text-anchor", "end")
                .attr("transform", "translate(-6," + gridSize / 1.5 + ")")
                .attr("class", function (d, i) { return ((i >= 0 && i <= 4) ? "dayLabel mono axis axis-workweek" : "dayLabel mono axis"); });

            var timeLabels = svg.selectAll(".timeLabel")
                .data(times)
                .enter().append("text")
                .text(function (d) { return d; })
                .attr("x", function (d, i) { return i * gridSize; })
                .attr("y", 0)
                .style("text-anchor", "middle")
                .attr("transform", "translate(" + gridSize / 2 + ", -6)")
                .attr("class", function (d, i) { return ((i >= 7 && i <= 16) ? "timeLabel mono axis axis-worktime" : "timeLabel mono axis"); });

            var heatmapChart = function (data) {
                
                var colorScale = d3.scale.quantile()
                    .domain([0, buckets - 1, d3.max(data, function (d) { return d.value; })])
                    .range(colors);

                var cards = svg.selectAll(".hour")
                    .data(data, function (d) { return d.day + ':' + d.hour;});
                
                cards.append("title");

                cards.enter().append("rect")
                    .attr("x", function (d) { return (d.hour - 1) * gridSize; })
                    .attr("y", function (d) { return (d.day - 1) * gridSize; })
                    .attr("rx", 4)
                    .attr("ry", 4)
                    .attr("class", "hour bordered")
                    .attr("width", gridSize)
                    .attr("height", gridSize)
                    .style("fill", colors[0]);

                cards.transition().duration(1000)
                    .style("fill", function (d) { return colorScale(d.value); });

                cards.select("title").text(function (d) { return d.value; });

                cards.exit().remove();

                var legend = svg.selectAll(".legend")
                    .data([0].concat(colorScale.quantiles()), function (d) { return d; });

                legend.enter().append("g")
                    .attr("class", "legend");

                legend.append("rect")
                    .attr("x", function (d, i) { return legendElementWidth * i; })
                    .attr("y", height)
                    .attr("width", legendElementWidth)
                    .attr("height", gridSize / 2)
                    .style("fill", function (d, i) { return colors[i]; });

                legend.append("text")
                    .attr("class", "mono")
                    .text(function (d) { return "≥ " + Math.round(d); })
                    .attr("x", function (d, i) { return legendElementWidth * i; })
                    .attr("y", height + gridSize);


                legend.exit().remove();

            };

            heatmapChart(data);
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

        <div class="barChart">
        </div>
        <div class="scatterChart"></div>
        <div class="heatMap"></div>

    </div>
</asp:Content>
