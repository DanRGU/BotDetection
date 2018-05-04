﻿<%@ Page Title="Bot Visualisation" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BotDetection._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div id="submission" class="page">
        <div id="intro" class="col-md-6">
            <h1>Bot Visualisation</h1>
            <p>Enter a Twitter Username and the site will retreive the tweets associated with it.  These will then be used to generate visualisations which may indicate wether the account is controlled by a human or not.</p>
        </div>
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <input id="userInput" placeholder="@username" />
                <button class="btn btn-info" id="userSubmit" onclick="getData()">Submit</button>
            </ContentTemplate>
        </asp:UpdatePanel>


        <div class="popup">
            <button class="btn btn-info" id="popupButton" onclick="return false;">Show Profile</button>
            <div id="popup-contents" class="hidden visuallyhidden">
                <div>
                    <h3 id="name"></h3>
                    <p id="screenName"></p>
                </div>
                <div id="infoContainer">
                    <div class="info">
                        <p class="infoTitle">Followers</p>
                        <p id="followers"></p>
                    </div>
                    <div class="info">
                        <p class="infoTitle">Tweets</p>
                        <p id="tweets"></p>
                    </div>
                    <div class="info">
                        <p class="infoTitle">Created</p>
                        <p id="created"></p>
                    </div>
                </div>
                <h3>Sections</h3>
                <p><a id="searchNav" href="#submission">Search</a></p>
                <div class="tooltip">
                    <p><a id="heatmapnav" href="#">Heat Map</a></p>
                    <span class="tooltiptext">The heatmap shows how long it has taken the user to retweet since the tweet was originally posted.  This can indicate if an account is constantly searching through Tweets for keywords and retweeting them to spread certain messages.</span>
                </div>
                <div class="tooltip">
                    <p><a id="piechartnav" href="#">Pie Chart</a></p>
                    <span class="tooltiptext">The pie chart shows how long it has taken the user to retweet since the tweet was originally posted.  This can indicate if an account is constantly searching through Tweets for keywords and retweeting them to spread certain messages.</span>
                </div>
                <div class="tooltip">
                    <p><a id="barchartnav" href="#">Bar Chart</a></p>
                    <span class="tooltiptext">The bar chart shows how long it has taken the user to retweet since the tweet was originally posted.  This can indicate if an account is constantly searching through Tweets for keywords and retweeting them to spread certain messages.</span>
                </div>
                <div class="tooltip">
                    <p><a id="sentimentnav" href="#">Sentiment Chart</a></p>
                    <span class="tooltiptext">The sentiment chart shows how long it has taken the user to retweet since the tweet was originally posted.  This can indicate if an account is constantly searching through Tweets for keywords and retweeting them to spread certain messages.</span>
                </div>
                <button class="btn btn-info" id="popupButtonOpen" onclick="return false;">Hide Info</button>
            </div>
        </div>




        <p id="noNameError" class="error">Please enter a username.</p>
        <p id="noUserError" class="error">Sorry!  That user doesn't exist.</p>
        <p id="noTweetsError" class="error">Sorry!  That user doesn't have any tweets.</p>
        <div id="spinnerCont" class="col-md-12">
            <div class="lds-ring">
                <div></div>
                <div></div>
                <div></div>
                <div></div>
            </div>
        </div>

    </div>

    <!--Heat Map Stuff-->
    <div id="heatmap" class="heatMap page">
        <h3 id="heatTitle">Heatmap of Users Tweets</h3>
        <div class="innerHeatMap"></div>
        <h3 id="heatCompareTitle">Example Heatmap of Bot Tweets</h3>

        <div class="innerHeatMap2">
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="compareButtons">
                        <button id="humanHeatMap" type="button" class="btn btn-info" onclick="drawHumanHeatMap();">Human</button>
                        <button id="botHeatMap" type="button" class="btn btn-info active" onclick="drawBotHeatMap();">Bot</button>

                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <!--/Heat Map Stuff-->

    <!--Pie Chart Stuff-->
    <div id="pieChart" class="pieChart row page">
        <div class="innerPieChart col-md-6">
            <h3 id="pieTitle">Time taken to Retweet</h3>
        </div>
        <div class="innerPieChart2 col-md-6">
            <h3 id="pieCompareTitle">Example Pie Chart of Bot Retweet times</h3>

            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="compareButtons">
                        <button id="humanPieChart" type="button" class="btn btn-info" onclick="drawHumanPieChart();">Human</button>
                        <button id="botPieChart" type="button" class="btn btn-info active" onclick="drawBotPieChart();">Bot</button>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

    </div>

    <!--/Pie Chart Stuff-->

    <!--Bar Chart Stuff-->
    <div id="barchart" class="barChart row page">
        <div class="innerBarChart col-md-6">
            <h3 id="barTitle">Frequency of User Tweets</h3>
        </div>
        <div class="innerBarChart2 col-md-6">
            <h3 id="barCompareTitle">Example Bar Chart of Bot Tweet Frequency</h3>
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="compareButtons">
                        <button id="humanBarChart" type="button" class="btn btn-info" onclick="drawHumanBarChart();">Human</button>
                        <button id="botBarChart" type="button" class="btn btn-info active" onclick="drawBotBarChart();">Bot</button>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <!--/Bar Chart Stuff-->


    <!--Sentiment Chart Stuff-->
    <div id="sentimentchart" class="sentimentChart row page">
        <div class="innerSentimentChart col-md-6">
            <h3 id="sentimentTitle">Sentiment of User Tweets</h3>
        </div>
        <div class="innerSentimentChart2 col-md-6">
            <h3 id="sentimentCompareTitle">Example Sentiment of Bot Tweets</h3>
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="compareButtons">
                        <button id="humanSentimentChart" type="button" class="btn btn-info" onclick="drawHumanSentimentChart();">Human</button>
                        <button id="botSentimentChart" type="button" class="btn btn-info active" onclick="drawBotSentimentChart();">Bot</button>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <!--/Sentiment Chart Stuff-->

    <script type="text/javascript">      


        //Global vars for switching between views (and on size change)
        var heatMapDataReload = botHeatData;
        var pieChartDataReload = botPieData;
        var barChartDataReload = botBarData;
        var sentimentChartDataReload = botSentimentData;


        //Setting the div sizes based on window size
        $(function () {
            $('.sentimentChart, .pieChart, .heatMap, .barChart, #submission').css({ height: $(window).outerHeight() });
            // $('.sentimentChart, .pieChart, .heatMap, .barChart, #submission').css({ width: $(window).innerWidth() });
            $(window).resize(function () {
                $('.sentimentChart, .pieChart, .heatMap, .barChart, #submission').css({ height: $(window).outerHeight() });
            });
            //  $(window).resize(function () {
            //     $('.sentimentChart, .pieChart, .heatMap, .barChart, #submission').css({ width: $(window).innerWidth() });
            //  });
        });

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
                    //More than 5 days
                    if (input[i].rtTime.day > 5) {
                        values[4]++;
                    }
                    //between 1 and 5 days
                    if (input[i].rtTime.day > 0 && input[i].rtTime.day <= 5) {
                        values[3]++;
                    }
                    //Less than a day but > 1 hour
                    if (input[i].rtTime.day == 0 && input[i].rtTime.hour > 0) {
                        values[2]++;
                    }
                    //less 1 hour mins but more than 5 seconds
                    if (input[i].rtTime.day == 0 && input[i].rtTime.hour == 0 && input[i].rtTime.minute > 0 || input[i].rtTime.day == 0 && input[i].rtTime.hour == 0 && input[i].rtTime.minute == 0 && input[i].rtTime.seconds > 30) {
                        values[1]++;
                    }
                    //less than 5 seconds
                    if (input[i].rtTime.day == 0 && input[i].rtTime.hour == 0 && input[i].rtTime.minute == 0 && input[i].rtTime.seconds < 5) {
                        values[0]++;
                    }
                }
            }

            var output = [];
            output.push({ label: "> 5 Days", count: values[4] }, { label: "1 - 5 Days", count: values[3] }, { label: "1 - 24 hours", count: values[2] }, { label: "5 seconds - 1 hour", count: values[1] }, { label: "< 5 seconds", count: values[0] }, );
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


        //Getting and formatting tweets (setting variables etc)
        function getData() {

            d3.select("#noUserError").style("display", "none");
            d3.select("#noNameError").style("display", "none");
            $("#MainContent_ctl00").removeClass("shake");

            if ($("#userInput").val() == "") {
                d3.select("#noNameError").style("display", "block");
                $("#MainContent_ctl00").addClass("shake");
                return;
            }


            $("#spinnerCont").css({ display: "block" });

            var name = "";
            var userName = "";
            var heatData = [];
            var pieChartData = [];
            var barChartData = [];
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
            var followers = 0;
            var createdAt;
            var numTweets = 0;

            var dataParam = $("#userInput").val();
            console.log(dataParam);



            $.ajax({
                // url: "/GetTweets.asmx/GetTwitterDataJSON",
                url: "https://botdetectionmanual.azurewebsites.net/GetTweets.asmx/GetTwitterDataJSON",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{ 'userID': '" + dataParam + "' }",
                success:

                    function (response) {
                        console.log(response.Message);
                        //Setting tweets to the JSON objects under d
                        var tweets = response.d.tweets;
                        if (response.d["userName"] != "" && response.d["followers"] != "" && response.d["numTweets"] >0) {


                            userName = response.d["userName"];
                            followers = response.d["followers"];
                            numTweets = response.d["numTweets"];
                            createdAt = new Date(parseFloat(response.d["created"].substr(6)));
                        }
                        else {
                            $("#MainContent_ctl00").addClass("shake");
                            d3.select("#noTweetsError").style("display", "block");
                            $("#spinnerCont").css({ display: "none" });
                            return;
                        }
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


                            if (name == "") {
                                name = response.d["screenName"];
                            }

                            if (i < 200) {
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

                        }
                        //Setting Data for charts
                        heatData = getHeatData(dates);
                        pieChartData = getPieData(retweetTimes);
                        barChartData = getBarData(dates);


                        if (document.readyState === "complete") {

                            //Drawing the charts
                            drawHeatmapChart(heatData, ".innerHeatMap");
                            drawHeatmapChart(botHeatData, ".innerHeatMap2");
                            console.log(pieChartData);
                            drawPieChart(pieChartData, ".innerPieChart");
                            drawPieChart(botPieData, ".innerPieChart2");

                            drawBarChart(barChartData, ".innerBarChart");
                            drawBarChart(botBarData, ".innerBarChart2");

                            drawSentimentChart(sentimentData, ".innerSentimentChart");
                            drawSentimentChart(botSentimentData, ".innerSentimentChart2");
                        }

                        $("#heatTitle").html("Heatmap of " + name + "'s Tweets");
                        $("#pieTitle").html("Time taken to Retweet by " + name);
                        $("#barTitle").html("Frequency of " + name + "'s Tweets");
                        $("#sentimentTitle").html("Sentiment of " + name + "'s Tweets");

                        const monthNames = ["January", "February", "March", "April", "May", "June",
                            "July", "August", "September", "October", "November", "December"
                        ];


                        $("#name").html(name);
                        $("#screenName").html("@" + userName);
                        $("#followers").html(followers);
                        $("#tweets").html(numTweets);
                        $("#created").html(monthNames[createdAt.getMonth()] + ", " + createdAt.getFullYear());

                        $("#spinnerCont").css({ display: "none" });
                        $(".popup").css({ display: "flex" });
                        $('html,body').stop().animate({ scrollTop: $(".heatMap").offset().top }, 'slow');

                    },
                error: function (response) {
                    console.log("FAILED");
                    console.log(response);
                    d3.select("#noUserError").style("display", "block");
                    $("#spinnerCont").css({ display: "none" });
                    $("#MainContent_ctl00").addClass("shake");
                }
            });


            $(window).resize(function () {

                drawHeatmapChart(heatData, ".innerHeatMap");
                drawHeatmapChart(heatMapDataReload, ".innerHeatMap2");


                drawPieChart(pieChartData, ".innerPieChart");
                drawPieChart(pieChartDataReload, ".innerPieChart2");

                drawBarChart(barChartData, ".innerBarChart");
                drawBarChart(barChartDataReload, ".innerBarChart2");

                drawSentimentChart(sentimentData, ".innerSentimentChart");
                drawSentimentChart(sentimentChartDataReload, ".innerSentimentChart2");
            });
        }

        //On button press draw the correct chart to compare against
        //Heatmap
        function drawBotHeatMap() {
            $("#heatCompareTitle").html("Example Heatmap of Bot Tweets");
            drawHeatmapChart(botHeatData, ".innerHeatMap2");
            heatMapDataReload = botHeatData;
            $("#botHeatMap").addClass("active");
            $("#humanHeatMap").removeClass("active");

        }
        function drawHumanHeatMap() {
            $("#heatCompareTitle").html("Example Heatmap of Human Tweets");
            drawHeatmapChart(humanHeatData, ".innerHeatMap2");
            heatMapDataReload = humanHeatData;
            $("#humanHeatMap").addClass("active");
            $("#botHeatMap").removeClass("active");
        }

        //PieChart
        function drawBotPieChart() {
            $("#pieCompareTitle").html("Example Pie Chart of Bot Retweet times");
            drawPieChart(botPieData, ".innerPieChart2");
            pieChartDataReload = botPieData;
            $("#botPieChart").addClass("active");
            $("#humanPieChart").removeClass("active");
        }
        function drawHumanPieChart() {
            $("#pieCompareTitle").html("Example Pie Chart of Human Retweet times");
            drawPieChart(humanPieData, ".innerPieChart2");
            pieChartDataReload = humanPieData;
            $("#botPieChart").removeClass("active");
            $("#humanPieChart").addClass("active");
        }

        //Bar Chart
        function drawBotBarChart() {
            $("#barCompareTitle").html("Example Bar Chart of Bot Tweet Frequency");
            drawBarChart(botBarData, ".innerBarChart2");
            pieChartDataReload = botBarData;
            $("#botBarChart").addClass("active");
            $("#humanBarChart").removeClass("active");
        }
        function drawHumanBarChart() {
            $("#barCompareTitle").html("Example Bar Chart of Human Tweet Frequency");
            drawBarChart(humanBarData, ".innerBarChart2");
            barChartDataReload = humanBarData;
            $("#botBarChart").removeClass("active");
            $("#humanBarChart").addClass("active");
        }

        //Bar Chart
        function drawBotSentimentChart() {
            $("#sentimentCompareTitle").html("Example Sentiment Chart of Bot Tweets");
            drawSentimentChart(botSentimentData, ".innerSentimentChart2");
            sentimentChartDataReload = sentimentBarData;
            $("#botSentimentChart").addClass("active");
            $("#humanSentimentChart").removeClass("active");
        }
        function drawHumanSentimentChart() {
            $("#sentimentCompareTitle").html("Example Sentiment Chart of Human Tweets");
            drawSentimentChart(humanSentimentData, ".innerSentimentChart2");
            sentimentChartDataReload = humanSentimentData;
            $("#botSentimentChart").removeClass("active");
            $("#humanSentimentChart").addClass("active");
        }

        $('#heatmapnav').click(function () {

            $('html,body').stop().animate({ scrollTop: $(".heatMap").offset().top }, 1000);
            closePopup();
        });

        $('#piechartnav').click(function () {

            $('html,body').stop().animate({ scrollTop: $(".pieChart").offset().top }, 1000);
            closePopup();
        });
        $('#barchartnav').click(function () {

            $('html,body').stop().animate({ scrollTop: $(".barChart").offset().top }, 1000);
            closePopup();
        });
        $('#sentimentnav').click(function () {

            $('html,body').stop().animate({ scrollTop: $(".sentimentChart").offset().top }, 1000);
            closePopup();
        });

        $('#popupButton').click(function () {
            openPopup();

        });

        function openPopup() {
            if ($('#popup-contents').hasClass('hidden')) {

                $('#popup-contents').removeClass('hidden');
                setTimeout(function () {
                    $('#popup-contents').removeClass('visuallyhidden');
                }, 20);

                $('#popupButton').css("display", "none");

            }
        }

        $('#popupButtonOpen').click(function () {

            closePopup();

        });
        function closePopup() {
            $('#popup-contents').addClass('visuallyhidden');
            $('#popup-contents').addClass('hidden');
            $('#popupButton').css("display", "block");
        }

    </script>

</asp:Content>

