<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BotDetection._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">

        //Tweet Frequency how many posts per day / per hour
        //RT time - (if the first 2 characters are RT or if RT = true get time of post and get time of original post then minus them and return time)

        function parseDate(input) {
            var date = new Date(input);
            var output = date.getHours() + " hour(s), " + date.getMinutes() + " minute(s), " + date.getSeconds() + "second(s)";
            return output;
        }
        //return the day of the week +1 (1-7)
        function checkDay(date) {
            return date.getDay() + 1;
        }
        //return the hour of the day +1 (to make it between 1-24)
        function checkHour() {
            return date.getHours() + 1;
        }
        //Create 2D array
        function createArray(length) {
            var arr = new Array(length || 0),
                i = length;

            if (arguments.length > 1) {
                var args = Array.prototype.slice.call(arguments, 1);
                while (i--) arr[length - 1 - i] = createArray.apply(this, args);
            }

            return arr;
        }
        //gather the data for the heatmap
        function getHeatData(input) {
            var days = createArray(7, 24);

            for (var i = 0; i < 7; i++) {
                for (var j = 0; j < 24; j++) {
                    days[i][j] = 0;
                }
            }
            //Loop for every date object and update the days value
            for (var i = 0; i < input.length; i++) {

                currentDate = new Date(input[i]);
                days[currentDate.getDay()][currentDate.getHours()]++;

            }
            var output = [];
            for (var d = 0; d < 7; d++) {
                for (var h = 0; h < 24; h++) {

                    if (days[d][h] == null) {

                        days[d][h] == 0;
                    }

                    output.push({ day: d + 1, hour: h + 1, value: days[d][h] }, )
                }
            }
            return output;
        }

        function getData() {
            if ($("#userInput").val() == ""){
                d3.select(".error").style("display", "block");
                return;
            }
            
            var dataParam = $("#userInput").val();

            $.ajax({
                url: "GetTweets.asmx/GetTwitterDataJSON",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{ 'userID': '" + dataParam + "' }",
                success:

                function (response) {

                    d3.select(".sentimentChart").selectAll("svg")
                        .each(function (d, i) {
                            this.remove();

                        });
                    d3.select(".heatMap").selectAll("svg")
                        .each(function (d, i) {
                            this.remove();

                        });

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
                    var sentimentData = [];

                    console.log(tweets.length);
                    //Looping for each tweet and adding the variables to the arrays
                    for (var i in tweets) {
                        var tweet = tweets[i];

                        //Tweet stuff
                        content.push(tweet["Content"]);
                        dates.push(new Date(parseFloat(tweet["PostTime"].substr(6))));
                       
                        retweets.push(tweet["retweets"]);
                        likes.push(tweet["likes"]);
                        sentimentScore.push(tweet["sentiment"]);
                        if(i < 250) {
                            sentimentData.push({ name: tweet["tweetID"], value: tweet["sentiment"] }, );
                            tweetLengths.push(content[i].length);
                        }
                    }
                    console.log(sentimentData);
                    var heatData = getHeatData(dates);

                    //Printing to output
                    for (var i = 0; i < tweets.length; i++) {
                        if (i < tweets.length - 1) {
                            timeSince.push(new Date(dates[i].getTime() - dates[i + 1].getTime()));
                        }
                        else {
                            timeSince.push(0);
                        }

                      /*  $("#twitterOutput").append(
                            content[i]
                            + "\nLength: "
                            + tweetLengths[i]
                            + "\nOn " + dates[i].toUTCString()
                            + "\n"
                            + "Time since last post " + parseDate(timeSince[i])
                            + "\n"
                            + "Tweet Analysis\n"
                            + "Sentiment Score : " + sentimentScore[i]
                            + "\n\n");*/

                    }

                    //Drawing the bar chart
                    drawBarChart(tweetLengths);
                    //drawScatterChart(scatterData);
                    drawHeatmapChart(heatData);
                    drawSentimentChart(sentimentData);

                    $(function () {
                        $('.sentimentChart, .barChart, .heatMap').css({ height: $(window).innerHeight() });
                        $(window).resize(function () {
                            $('.div1, .div2').css({ height: $(window).innerHeight() });
                        });
                    });

                    $('html,body').animate({
                        scrollTop: $(".sentimentChart").offset().top
                    },
                        'slow');
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

            d3.select(".barChart").style("display","block");
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
                width = 700 - margin.left - margin.right,
                height = 350 - margin.top - margin.bottom,
                gridSize = Math.floor(width / 24),
                legendElementWidth = gridSize * 2.66666666667,
                buckets = 9,
                colors = ["#ffffd9", "#edf8b1", "#c7e9b4", "#7fcdbb", "#41b6c4", "#1d91c0", "#225ea8", "#253494", "#081d58"], // alternatively colorbrewer.YlGnBu[9]
                days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"],
                times = ["1a", "2a", "3a", "4a", "5a", "6a", "7a", "8a", "9a", "10a", "11a", "12a", "1p", "2p", "3p", "4p", "5p", "6p", "7p", "8p", "9p", "10p", "11p", "12p"];


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
                    .data(data, function (d) { return d.day + ':' + d.hour; });

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
            d3.select(".heatMap").style("display", "block");
        }

        function drawSentimentChart(data) {

            var margin = { top: 20, right: 30, bottom: 40, left: 30 },
                width = 500 - margin.left - margin.right,
                height = 500 - margin.top - margin.bottom;

            var x = d3.scale.linear()
                .range([0, width]);

            var y = d3.scale.ordinal()
                .rangeRoundBands([0, height], 0.1);

            var xAxis = d3.svg.axis()
                .scale(x)
                .orient("bottom");

            var yAxis = d3.svg.axis()
                .scale(y)
                .orient("left")
                .tickSize(0)
                .tickPadding(6);

            var svg = d3.select(".sentimentChart").append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

                x.domain(d3.extent(data, function (d) { return d.value; })).nice();
                y.domain(data.map(function (d) { return d.name; }));

                svg.selectAll(".bar")
                    .data(data)
                    .enter().append("rect")
                    .attr("class", function (d) { return "bar bar--" + (d.value < 0 ? "negative" : "positive"); })
                    .attr("x", function (d) { return x(Math.min(0, d.value)); })
                    .attr("y", function (d) { return y(d.name); })
                    .attr("width", function (d) { return Math.abs(x(d.value) - x(0)); })
                    .attr("height", y.rangeBand());

                svg.append("g")
                    .attr("class", "x axis")
                    .attr("transform", "translate(0," + height + ")")
                    .call(xAxis);

                svg.append("g")
                    .attr("class", "y axis")
                    .attr("transform", "translate(" + x(0) + ",0)")
                    .call(yAxis);

                svg.select(".y").selectAll("text")
                    .each(function (d, i) {
                            this.remove();

                    });

                d3.select(".sentimentChart").style("display","block");
        };
    </script>

        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <div id="submission">
                    <input id="userInput" />
                    <button id="userSubmit" onclick="getData()"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
                    <p class="error">Please put in a name</p>
                </div>

                <textarea id="twitterOutput"></textarea>
            </ContentTemplate>
        </asp:UpdatePanel>

    <div class="sentimentChart"></div>
    <div class="heatMap"></div>
    <div class="barChart"></div>
</asp:Content>
