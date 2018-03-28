<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BotDetection._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
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
        <div class="heatMap">
                <h3>Heatmap of Users Tweets</h3>
            </div>  
        <div class="pieChart"><h3>Time taken to Retweet</h3></div>
        <div class="barChart"><h3>Frequency of User Tweets</h3></div>
        <div class="sentimentChart"><h3>Sentiment of Users Tweets</h3></div>


    <script type="text/javascript">         


        $(function () {
            $('.sentimentChart, .pieChart, .heatMap, .barChart, #MainContent_ctl00').css({ height: $(window).innerHeight() });
            $(window).resize(function () {
                $('.sentimentChart, .pieChart, .heatMap, .barChart, #MainContent_ctl00').css({ height: $(window).innerHeight() });
            });
        });

        $(function () {
            $('.sentimentChart, .pieChart, .heatMap, .barChart, #MainContent_ctl00').css({ witdh: $(window).innerWidth() });
            $(window).resize(function () {
                $('.sentimentChart, .pieChart, .heatMap, .barChart, #MainContent_ctl00').css({ width: $(window).innerWidth() });
            });
        });



        //Formatting the date for text output
        function parseDate(input) {
            var date = new Date(input);
            var output = date.getHours() + " hour(s), " + date.getMinutes() + " minute(s), " + date.getSeconds() + "second(s)";
            return output;
        }
        //Convert a ms date to days, hours mins etc...
        function convertMS(milliseconds) {
            var day, hour, minute, seconds;
            if (milliseconds < 636150829400 && milliseconds > 0) {

                seconds = Math.floor(milliseconds / 1000);
                minute = Math.floor(seconds / 60);
                seconds = seconds % 60;
                hour = Math.floor(minute / 60);
                minute = minute % 60;
                day = Math.floor(hour / 24);
                hour = hour % 24;
            }
            else {
                seconds = 0;
                minute = 0;
                hour = 0;
                day = 999999;
            }
            return {
                day: day,
                hour: hour,
                minute: minute,
                seconds: seconds
            };
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

        //gather data for the pie chart
        function getPieData(input) {
            var values = [0, 0, 0, 0, 0];

            for (var i = 0; i < input.length; i++) {

                if (input[i].rtTime.day != 999999) {
                    //More than 3 days
                    if (input[i].rtTime.day > 5) {
                        values[4]++;
                    }
                    //between 1 and 5 days
                    if (input[i].rtTime.day > 0 && input[i].rtTime.day <= 5) {
                        values[3]++;
                    }
                    //Less than a day but > 1 hour
                    if (input[i].rtTime.day == 0 && input[i].rtTime.hour < 0) {
                        values[2]++;
                    }
                    //less than an hour but more than 30 seconds
                    if (input[i].rtTime.day == 0 && input[i].rtTime.hour == 0 && input[i].rtTime.minute > 0 || input[i].rtTime.day == 0 && input[i].rtTime.hour == 0 && input[i].rtTime.minute < 0 && input[i].rtTime.seconds > 30) {
                        values[1]++;
                    }
                    //less than 30 seconds
                    if (input[i].rtTime.day == 0 && input[i].rtTime.hour == 0 && input[i].rtTime.minute == 0 && input[i].rtTime.seconds < 31) {
                        values[0]++;
                    }
                }
            }

            var output = [];
            output.push({ label: "> 3 Days", count: values[4] }, { label: "1 - 5 Days", count: values[3] }, { label: "< a Day", count: values[2] }, { label: "< 1 Hour", count: values[1] }, { label: "< 30 seconds", count: values[0] }, );
            return output;
        }

        //gather data for the bar chart
        function getBarData(input) {
            //need a list of months and how many tweets in those months
            //in total or for this year?
            var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
            var output = [];
            var values = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

            for (var i = 0; i < input.length; i++) {
                var month = input[i].getMonth();
                values[month]++;
            }
            for (var j = 0; j < months.length; j++) {
                output.push(
                    { letter: months[j], frequency: values[j] }, );
            }

            return output;
        }


        /**
         * GLOBAL VARIABLES
         */
        var heatData;
        var pieChartData;
        var barChartData;
        var id = [];
        var content = [];
        var retweets = [];
        var likes = [];
        var dates = [];
        var retweeted = [];
        var tweetLengths = [];
        var timeSince = [];
        var sentimentScore = [];
        var sentimentData = [];
        var retweetTimes = [];
        var originalTimes = [];

        function getData() {
            if ($("#userInput").val() == "") {
                d3.select(".error").style("display", "block");
                return;
            }

            var dataParam = $("#userInput").val();

            $.ajax({
                url: "https://botdetectionmanual.azurewebsites.net/GetTweets.asmx/GetTwitterDataJSON",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{ 'userID': '" + dataParam + "' }",
                success:

                function (response) {

                    //Setting tweets to the JSON objects under d
                    var tweets = response.d;

                    //test
                    //Initialising the variables for the tweets



                    //Looping for each tweet and adding the variables to the arrays
                    for (var i in tweets) {
                        var tweet = tweets[i];

                        //Tweet stuff
                        id.push(tweet["tweetID"]);
                        content.push(tweet["Content"]);
                        dates.push(new Date(parseFloat(tweet["PostTime"].substr(6))));
                        originalTimes.push(new Date(parseFloat(tweet["RetweetTime"].substr(6))));
                        retweeted.push(tweet["Retweeted"]);
                        retweets.push(tweet["retweets"]);
                        likes.push(tweet["likes"]);
                        sentimentScore.push(tweet["sentiment"]);

                        if (i < 250) {
                            sentimentData.push({ name: tweet["tweetID"], value: tweet["sentiment"] }, );
                            tweetLengths.push(content[i].length);
                        }
                    }

                    for (var i = 0; i < tweets.length; i++) {
                        if (i < tweets.length - 1) {
                            timeSince.push(new Date(dates[i].getTime() - dates[i + 1].getTime()));
                        }
                        else {
                            timeSince.push(0);
                        }

                        var time = convertMS(dates[i] - originalTimes[i]);

                        retweetTimes.push({ id: id[i], rtTime: time });


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
                            + "\n Retweeted " + retweeted[i]
                            + "\nRetweeted in " + retweetTimes[i].rtTime.day + " days, " + retweetTimes[i].rtTime.hour + " hours, " + retweetTimes[i].rtTime.minute + " minutes, " + retweetTimes[i].rtTime.seconds + " seconds"
                            + "\n\n");

                    }
                    heatData = getHeatData(dates);
                    pieChartData = getPieData(retweetTimes);
                    barChartData = getBarData(dates);

                    drawHeatmapChart(heatData);
                    drawSentimentChart(sentimentData);
                    drawPieChart(pieChartData);
                    drawBarChart(barChartData);

                    $('html,body').animate({ scrollTop: $(".heatMap").offset().top }, 'slow');

                    /*   $(function () {
                           //Keep track of last scroll
                           var divs = [".heatMap", ".pieChart", ".barChart", ".sentimentChart"];
                           var lastScroll = 0;
                           var position = 0;
   
                           $(window).scroll(function (event) {
                               //Sets the current scroll position
                               var st = $(this).scrollTop();
                               //Determines up-or-down scrolling
                               if (st > lastScroll) {
                                   //DOWN
                                   event.preventDefault();
                                   $('html, body').animate({
                                       scrollTop: $(divs[position]).offset().top
                                   }, 'slow');
                                   position++;
                               }
                               else {
                                   //UP
                                   $('html, body').animate({
                                       scrollTop: $(divs[position]-1).offset().top
                                   }, 'slow');
                                   position--;
                               }
                               //Updates scroll position
                               lastScroll = st;
                           });
                       });*/
                }
            });
        }

        $(window).resize(function () {

            drawHeatmapChart(heatData);
            drawSentimentChart(sentimentData);
            drawPieChart(pieChartData);
            drawBarChart(barChartData);
        });

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

            d3.select(".heatMap").selectAll("svg")
                .each(function (d, i) {
                    this.remove();

                });

            var margin = { top: 50, right: 0, bottom: 100, left: 30 },
                width = $(window).innerWidth() / 1.2 - margin.left - margin.right,
                height = $(window).innerHeight() / 1.2 - margin.top - margin.bottom,
                gridSize = Math.floor(width / 24),
                legendElementWidth = gridSize / 2,
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
                    .attr("y", gridSize * 7.3)
                    .attr("width", legendElementWidth)
                    .attr("height", gridSize / 2)
                    .style("fill", function (d, i) { return colors[i]; });

                legend.append("text")
                    .attr("class", "mono")
                    .text("Low to High")
                    .attr("x", legendElementWidth)
                    .attr("y", gridSize * 8.3);


                legend.exit().remove();

            };

            heatmapChart(data);
            d3.select(".heatMap").style("display", "block");
        }

        function drawSentimentChart(data) {

            d3.select(".sentimentChart").selectAll("svg")
                .each(function (d, i) {
                    this.remove();

                });

            var margin = { top: 20, right: 30, bottom: 40, left: 30 },
                width = $(window).innerWidth() / 1.5 - margin.left - margin.right,
                height = $(window).innerHeight() / 1.5 - margin.top - margin.bottom;

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

            d3.select(".sentimentChart").style("display", "block");
        };

        function drawPieChart(dataset) {

            d3.select(".pieChart").selectAll("svg")
                .each(function (d, i) {
                    this.remove();

                });
            var width = $(window).innerWidth() / 1.5;
            var height = $(window).innerHeight() / 1.5;
            var radius = Math.min(width, height) / 2;
            var donutWidth = 75;
            var color = d3.scale.category10();
            var legendRectSize = 18;
            var legendSpacing = 4;

            var svg = d3.select('.pieChart')
                .append('svg')
                .attr('width', width)
                .attr('height', height)
                .append('g')
                .attr('transform', 'translate(' + (width / 2) +
                ',' + (height / 2) + ')');

            var arc = d3.svg.arc()
                .innerRadius(radius - donutWidth)
                .outerRadius(radius);

            var pie = d3.layout.pie()
                .value(function (d) { return d.count; })
                .sort(null);

            var path = svg.selectAll('path')
                .data(pie(dataset))
                .enter()
                .append('path')
                .attr('d', arc)
                .attr('fill', function (d, i) {
                    return color(d.data.label);
                });

            var legend = svg.selectAll('.legend')
                .data(color.domain())
                .enter()
                .append('g')
                .attr('class', 'legend')
                .attr('transform', function (d, i) {
                    var height = legendRectSize + legendSpacing;
                    var offset = height * color.domain().length / 2;
                    var horz = -2 * legendRectSize;
                    var vert = i * height - offset;
                    return 'translate(' + horz + ',' + vert + ')';
                });

            legend.append('rect')
                .attr('width', legendRectSize)
                .attr('height', legendRectSize)
                .style('fill', color)
                .style('stroke', color);
            legend.append('text')
                .attr('x', legendRectSize + legendSpacing)
                .attr('y', legendRectSize - legendSpacing)
                .text(function (d) { return d; });

            d3.select(".pieChart").style("display", "block");

        }

        function drawBarChart(data) {

            d3.select(".barChart").selectAll("svg")
                .each(function (d, i) {
                    this.remove();

                });
            console.log(data);

            var margin = { top: 40, right: 20, bottom: 30, left: 40 },
                width = $(window).innerWidth() /1.5  - margin.left - margin.right,
                height = $(window).innerHeight() /1.5 - margin.top - margin.bottom;


            var x = d3.scale.ordinal()
                .rangeRoundBands([0, width], .1);

            var y = d3.scale.linear()
                .range([height, 0]);

            var xAxis = d3.svg.axis()
                .scale(x)
                .orient("bottom");

            var yAxis = d3.svg.axis()
                .scale(y)
                .orient("left");

            var svg = d3.select(".barChart").append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


            // The following code was contained in the callback function.
            x.domain(data.map(function (d) { return d.letter; }));
            y.domain([0, d3.max(data, function (d) { return d.frequency; })]);

            svg.append("g")
                .attr("class", "x axis")
                .attr("transform", "translate(0," + height + ")")
                .call(xAxis);

            svg.append("g")
                .attr("class", "y axis")
                .call(yAxis)
                .append("text")
                .attr("transform", "rotate(-90)")
                .attr("y", 6)
                .attr("dy", ".71em")
                .style("text-anchor", "end")
                .text("Frequency");

            svg.selectAll(".bar")
                .data(data)
                .enter().append("rect")
                .attr("class", "bar")
                .attr("x", function (d) { return x(d.letter); })
                .attr("width", x.rangeBand())
                .attr("y", function (d) { return y(d.frequency); })
                .attr("height", function (d) { return height - y(d.frequency); })

            d3.select(".barChart").style("display", "block");
        }

    </script>

</asp:Content>
