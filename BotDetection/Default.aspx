<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BotDetection._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div id="submission">
                <input id="userInput" />
                <button id="userSubmit" onclick="getData()"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
                 <p class="error">Please put in a name</p>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
   
    <!--Heat Map Stuff-->
    <div class="heatMap">
        <h3>Heatmap of Users Tweets</h3>
        <div class="innerHeatMap"></div>
            <h3 id="heatCompareTitle">Example Heatmap of Human Tweets</h3>
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="compareButtons">
                        <button id="humanHeatMap" type="button" class="btn btn-info" onclick="drawHumanHeatMap();">Human</button>
                        <button id="botHeatMap" type="button" class="btn btn-info" onclick="drawBotHeatMap();">Bot</button>
                        
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div class="innerHeatMap2"></div>
    </div>
    <!--/Heat Map Stuff-->

    <!--Pie Chart Stuff-->
    <div class="pieChart row">   
        <div class="innerPieChart col-md-6"> 
            <h3>Time taken to Retweet</h3>
        </div>
            <div class="innerPieChart2 col-md-6">
                <h3 id="pieCompareTitle">Example Pie Chart of Human Retweet times</h3>
                <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="compareButtons">
                        <button id="humanPieChart" type="button" class="btn btn-info" onclick="drawHumanPieChart();">Human</button>
                        <button id="botPieChart" type="button" class="btn btn-info" onclick="drawBotPieChart();">Bot</button>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            </div>

    </div>

    <!--/Pie Chart Stuff-->

    <!--Bar Chart Stuff-->
    <div class="barChart row">
        <div class="innerBarChart col-md-6"> 
            <h3>Frequency of User Tweets</h3>
        </div>
            <div class="innerBarChart2 col-md-6">
                <h3 id="barCompareTitle">Example Bar Chart of Human Tweet Frequency</h3>
                <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="compareButtons">
                        <button id="humanBarChart" type="button" class="btn btn-info" onclick="drawHumanBarChart();">Human</button>
                        <button id="botBarChart" type="button" class="btn btn-info" onclick="drawBotBarChart();">Bot</button>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            </div>
    </div>
    <!--/Bar Chart Stuff-->

    
    <!--Sentiment Chart Stuff-->
    <div class="sentimentChart">
        <h3>Sentiment of Users Tweets</h3>
    </div>
    <!--/Sentiment Chart Stuff-->

    <script type="text/javascript">      

        //Global vars for switching between views (and on size change)
        var heatMapDataReload = botHeatData;
        var pieChartDataReload = botPieData;
        var barChartDataReload = botBarData;
        var lineChartDataReload = botHeatData;


        //Setting the div sizes based on window size
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

        //Getting and formatting tweets (setting variables etc)
        function getData() {
            if ($("#userInput").val() == "") {
                d3.select(".error").style("display", "block");
                return;
            }

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

            var dataParam = $("#userInput").val();

            $.ajax({
                url: "/GetTweets.asmx/GetTwitterDataJSON",
                //url: "https://botdetectionmanual.azurewebsites.net/GetTweets.asmx/GetTwitterDataJSON",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{ 'userID': '" + dataParam + "' }",
                success:

                function (response) {

                    //Setting tweets to the JSON objects under d
                    var tweets = response.d;

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

                    }
                    //Setting Data for charts
                    heatData = getHeatData(dates);
                    pieChartData = getPieData(retweetTimes);
                    barChartData = getBarData(dates);
                    console.log(pieChartData);


                    //Drawing the charts
                    drawHeatmapChart(heatData, ".innerHeatMap");
                    drawHeatmapChart(botHeatData, ".innerHeatMap2");
                    
                    drawPieChart(pieChartData, ".innerPieChart");
                    drawPieChart(botPieData, ".innerPieChart2");

                    drawBarChart(barChartData, ".innerBarChart");
                    drawBarChart(botBarData, ".innerBarChart2");

                    drawSentimentChart(sentimentData);
                    

                    $('html,body').animate({ scrollTop: $(".heatMap").offset().top }, 'slow');

                    /*  $(function () {
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
                                  event.stopPropagation();
                                  $('html, body').animate({
                                      scrollTop: $(divs[position]).offset().top
                                  }, 'slow');
                                  position++;
                                  
                              }
                              else {
                                  //UP
                                  event.preventDefault();
                                  event.stopPropagation();
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
            $(window).resize(function () {

                drawHeatmapChart(heatData, ".innerHeatMap");
                drawHeatmapChart(heatMapDataReload, ".innerHeatMap2");

              
                drawPieChart(pieChartData, ".innerPieChart");
                drawPieChart(pieChartDataReload, ".innerPieChart2");
                
                drawBarChart(barChartData, ".innerBarChart");
                drawBarChart(barChartDataReload, ".innerBarChart2");

                drawSentimentChart(sentimentData);
            });
        }

        //On button press draw the correct chart to compare against
        //Heatmap
        function drawBotHeatMap() {
            $("#heatCompareTitle").html("Example Heatmap of Bot Tweets");
            drawHeatmapChart(botHeatData, ".innerHeatMap2");
            heatMapDataReload = botHeatData;
        }
        function drawHumanHeatMap() {
            $("#heatCompareTitle").html("Example Heatmap of Human Tweets");
            drawHeatmapChart(humanHeatData, ".innerHeatMap2");
            heatMapDataReload = humanHeatData;
        }

        //PieChart
        function drawBotPieChart() {
            $("#pieCompareTitle").html("Example Pie Chart of Bot Retweet times");
            drawPieChart(botPieData, ".innerPieChart2");
            pieChartDataReload = botPieData;
        }
        function drawHumanPieChart() {
            $("#pieCompareTitle").html("Example Pie Chart of Human Retweet times");
            drawPieChart(humanPieData, ".innerPieChart2");
            pieChartDataReload = humanPieData;
        }

        //Bar Chart
        function drawBotBarChart() {
            $("#barCompareTitle").html("Example Bar Chart of Human Tweet Frequency");
            drawBarChart(botBarData, ".innerBarChart2");
            pieChartDataReload = botBarData;
        }
        function drawHumanBarChart() {
            $("#barCompareTitle").html("Example Bar Chart of Human Tweet Frequency");
            drawBarChart(humanBarData, ".innerBarChart2");
            barChartDataReload = humanBarData;
        }

       

        //Sample data to compare against

        var humanHeatData = [
            { day: 1, hour: 1, value: 2 },
            { day: 1, hour: 2, value: 2 },
            { day: 1, hour: 3, value: 0 },
            { day: 1, hour: 4, value: 0 },
            { day: 1, hour: 5, value: 0 },
            { day: 1, hour: 6, value: 0 },
            { day: 1, hour: 7, value: 0 },
            { day: 1, hour: 8, value: 0 },
            { day: 1, hour: 9, value: 1 },
            { day: 1, hour: 10, value: 2 },
            { day: 1, hour: 11, value: 5 },
            { day: 1, hour: 12, value: 2 },
            { day: 1, hour: 13, value: 3 },
            { day: 1, hour: 14, value: 6 },
            { day: 1, hour: 15, value: 3 },
            { day: 1, hour: 16, value: 4 },
            { day: 1, hour: 17, value: 3 },
            { day: 1, hour: 18, value: 1 },
            { day: 1, hour: 19, value: 1 },
            { day: 1, hour: 20, value: 4 },
            { day: 1, hour: 21, value: 2 },
            { day: 1, hour: 22, value: 3 },
            { day: 1, hour: 23, value: 3 },
            { day: 1, hour: 24, value: 5 },
            { day: 2, hour: 1, value: 2 },
            { day: 2, hour: 2, value: 4 },
            { day: 2, hour: 3, value: 2 },
            { day: 2, hour: 4, value: 0 },
            { day: 2, hour: 5, value: 0 },
            { day: 2, hour: 6, value: 0 },
            { day: 2, hour: 7, value: 1 },
            { day: 2, hour: 8, value: 0 },
            { day: 2, hour: 9, value: 0 },
            { day: 2, hour: 10, value: 9 },
            { day: 2, hour: 11, value: 7 },
            { day: 2, hour: 12, value: 4 },
            { day: 2, hour: 13, value: 7 },
            { day: 2, hour: 14, value: 8 },
            { day: 2, hour: 15, value: 7 },
            { day: 2, hour: 16, value: 3 },
            { day: 2, hour: 17, value: 2 },
            { day: 2, hour: 18, value: 5 },
            { day: 2, hour: 19, value: 0 },
            { day: 2, hour: 20, value: 0 },
            { day: 2, hour: 21, value: 3 },
            { day: 2, hour: 22, value: 3 },
            { day: 2, hour: 23, value: 10 },
            { day: 2, hour: 24, value: 4 },
            { day: 3, hour: 1, value: 2 },
            { day: 3, hour: 2, value: 0 },
            { day: 3, hour: 3, value: 1 },
            { day: 3, hour: 4, value: 0 },
            { day: 3, hour: 5, value: 0 },
            { day: 3, hour: 6, value: 0 },
            { day: 3, hour: 7, value: 0 },
            { day: 3, hour: 8, value: 0 },
            { day: 3, hour: 9, value: 7 },
            { day: 3, hour: 10, value: 4 },
            { day: 3, hour: 11, value: 4 },
            { day: 3, hour: 12, value: 5 },
            { day: 3, hour: 13, value: 6 },
            { day: 3, hour: 14, value: 12 },
            { day: 3, hour: 15, value: 6 },
            { day: 3, hour: 16, value: 2 },
            { day: 3, hour: 17, value: 4 },
            { day: 3, hour: 18, value: 2 },
            { day: 3, hour: 19, value: 2 },
            { day: 3, hour: 20, value: 5 },
            { day: 3, hour: 21, value: 2 },
            { day: 3, hour: 22, value: 1 },
            { day: 3, hour: 23, value: 2 },
            { day: 3, hour: 24, value: 8 },
            { day: 4, hour: 1, value: 12 },
            { day: 4, hour: 2, value: 10 },
            { day: 4, hour: 3, value: 1 },
            { day: 4, hour: 4, value: 3 },
            { day: 4, hour: 5, value: 1 },
            { day: 4, hour: 6, value: 0 },
            { day: 4, hour: 7, value: 0 },
            { day: 4, hour: 8, value: 3 },
            { day: 4, hour: 9, value: 3 },
            { day: 4, hour: 10, value: 3 },
            { day: 4, hour: 11, value: 6 },
            { day: 4, hour: 12, value: 3 },
            { day: 4, hour: 13, value: 2 },
            { day: 4, hour: 14, value: 2 },
            { day: 4, hour: 15, value: 1 },
            { day: 4, hour: 16, value: 5 },
            { day: 4, hour: 17, value: 14 },
            { day: 4, hour: 18, value: 1 },
            { day: 4, hour: 19, value: 0 },
            { day: 4, hour: 20, value: 0 },
            { day: 4, hour: 21, value: 1 },
            { day: 4, hour: 22, value: 2 },
            { day: 4, hour: 23, value: 5 },
            { day: 4, hour: 24, value: 3 },
            { day: 5, hour: 1, value: 6 },
            { day: 5, hour: 2, value: 7 },
            { day: 5, hour: 3, value: 6 },
            { day: 5, hour: 4, value: 1 },
            { day: 5, hour: 5, value: 1 },
            { day: 5, hour: 6, value: 0 },
            { day: 5, hour: 7, value: 0 },
            { day: 5, hour: 8, value: 2 },
            { day: 5, hour: 9, value: 7 },
            { day: 5, hour: 10, value: 9 },
            { day: 5, hour: 11, value: 6 },
            { day: 5, hour: 12, value: 2 },
            { day: 5, hour: 13, value: 4 },
            { day: 5, hour: 14, value: 2 },
            { day: 5, hour: 15, value: 2 },
            { day: 5, hour: 16, value: 0 },
            { day: 5, hour: 17, value: 1 },
            { day: 5, hour: 18, value: 1 },
            { day: 5, hour: 19, value: 2 },
            { day: 5, hour: 20, value: 4 },
            { day: 5, hour: 21, value: 2 },
            { day: 5, hour: 22, value: 3 },
            { day: 5, hour: 23, value: 4 },
            { day: 5, hour: 24, value: 3 },
            { day: 6, hour: 1, value: 10 },
            { day: 6, hour: 2, value: 6 },
            { day: 6, hour: 3, value: 0 },
            { day: 6, hour: 4, value: 1 },
            { day: 6, hour: 5, value: 1 },
            { day: 6, hour: 6, value: 0 },
            { day: 6, hour: 7, value: 0 },
            { day: 6, hour: 8, value: 6 },
            { day: 6, hour: 9, value: 5 },
            { day: 6, hour: 10, value: 9 },
            { day: 6, hour: 11, value: 10 },
            { day: 6, hour: 12, value: 8 },
            { day: 6, hour: 13, value: 4 },
            { day: 6, hour: 14, value: 7 },
            { day: 6, hour: 15, value: 5 },
            { day: 6, hour: 16, value: 4 },
            { day: 6, hour: 17, value: 8 },
            { day: 6, hour: 18, value: 8 },
            { day: 6, hour: 19, value: 8 },
            { day: 6, hour: 20, value: 10 },
            { day: 6, hour: 21, value: 4 },
            { day: 6, hour: 22, value: 1 },
            { day: 6, hour: 23, value: 2 },
            { day: 6, hour: 24, value: 1 },
            { day: 7, hour: 1, value: 0 },
            { day: 7, hour: 2, value: 6 },
            { day: 7, hour: 3, value: 0 },
            { day: 7, hour: 4, value: 1 },
            { day: 7, hour: 5, value: 1 },
            { day: 7, hour: 6, value: 0 },
            { day: 7, hour: 7, value: 1 },
            { day: 7, hour: 8, value: 1 },
            { day: 7, hour: 9, value: 8 },
            { day: 7, hour: 10, value: 9 },
            { day: 7, hour: 11, value: 2 },
            { day: 7, hour: 12, value: 7 },
            { day: 7, hour: 13, value: 4 },
            { day: 7, hour: 14, value: 3 },
            { day: 7, hour: 15, value: 7 },
            { day: 7, hour: 16, value: 2 },
            { day: 7, hour: 17, value: 2 },
            { day: 7, hour: 18, value: 2 },
            { day: 7, hour: 19, value: 5 },
            { day: 7, hour: 20, value: 4 },
            { day: 7, hour: 21, value: 5 },
            { day: 7, hour: 22, value: 0 },
            { day: 7, hour: 23, value: 1 },
            { day: 7, hour: 24, value: 4 }];
        var botHeatData = [
            { day: 1, hour: 1, value: 0 },
            { day: 1, hour: 2, value: 0 },
            { day: 1, hour: 3, value: 6 },
            { day: 1, hour: 4, value: 0 },
            { day: 1, hour: 5, value: 0 },
            { day: 1, hour: 6, value: 11 },
            { day: 1, hour: 7, value: 0 },
            { day: 1, hour: 8, value: 0 },
            { day: 1, hour: 9, value: 14 },
            { day: 1, hour: 10, value: 0 },
            { day: 1, hour: 11, value: 0 },
            { day: 1, hour: 12, value: 9 },
            { day: 1, hour: 13, value: 0 },
            { day: 1, hour: 14, value: 3 },
            { day: 1, hour: 15, value: 14 },
            { day: 1, hour: 16, value: 0 },
            { day: 1, hour: 17, value: 0 },
            { day: 1, hour: 18, value: 9 },
            { day: 1, hour: 19, value: 0 },
            { day: 1, hour: 20, value: 0 },
            { day: 1, hour: 21, value: 9 },
            { day: 1, hour: 22, value: 0 },
            { day: 1, hour: 23, value: 1 },
            { day: 1, hour: 24, value: 12 },
            { day: 2, hour: 1, value: 0 },
            { day: 2, hour: 2, value: 2 },
            { day: 2, hour: 3, value: 15 },
            { day: 2, hour: 4, value: 0 },
            { day: 2, hour: 5, value: 1 },
            { day: 2, hour: 6, value: 16 },
            { day: 2, hour: 7, value: 0 },
            { day: 2, hour: 8, value: 0 },
            { day: 2, hour: 9, value: 13 },
            { day: 2, hour: 10, value: 0 },
            { day: 2, hour: 11, value: 2 },
            { day: 2, hour: 12, value: 15 },
            { day: 2, hour: 13, value: 0 },
            { day: 2, hour: 14, value: 1 },
            { day: 2, hour: 15, value: 8 },
            { day: 2, hour: 16, value: 0 },
            { day: 2, hour: 17, value: 2 },
            { day: 2, hour: 18, value: 8 },
            { day: 2, hour: 19, value: 0 },
            { day: 2, hour: 20, value: 3 },
            { day: 2, hour: 21, value: 4 },
            { day: 2, hour: 22, value: 0 },
            { day: 2, hour: 23, value: 3 },
            { day: 2, hour: 24, value: 7 },
            { day: 3, hour: 1, value: 0 },
            { day: 3, hour: 2, value: 0 },
            { day: 3, hour: 3, value: 13 },
            { day: 3, hour: 4, value: 0 },
            { day: 3, hour: 5, value: 2 },
            { day: 3, hour: 6, value: 10 },
            { day: 3, hour: 7, value: 0 },
            { day: 3, hour: 8, value: 3 },
            { day: 3, hour: 9, value: 12 },
            { day: 3, hour: 10, value: 0 },
            { day: 3, hour: 11, value: 2 },
            { day: 3, hour: 12, value: 6 },
            { day: 3, hour: 13, value: 0 },
            { day: 3, hour: 14, value: 3 },
            { day: 3, hour: 15, value: 6 },
            { day: 3, hour: 16, value: 0 },
            { day: 3, hour: 17, value: 3 },
            { day: 3, hour: 18, value: 3 },
            { day: 3, hour: 19, value: 0 },
            { day: 3, hour: 20, value: 1 },
            { day: 3, hour: 21, value: 8 },
            { day: 3, hour: 22, value: 0 },
            { day: 3, hour: 23, value: 1 },
            { day: 3, hour: 24, value: 14 },
            { day: 4, hour: 1, value: 0 },
            { day: 4, hour: 2, value: 2 },
            { day: 4, hour: 3, value: 10 },
            { day: 4, hour: 4, value: 0 },
            { day: 4, hour: 5, value: 1 },
            { day: 4, hour: 6, value: 10 },
            { day: 4, hour: 7, value: 0 },
            { day: 4, hour: 8, value: 2 },
            { day: 4, hour: 9, value: 12 },
            { day: 4, hour: 10, value: 0 },
            { day: 4, hour: 11, value: 1 },
            { day: 4, hour: 12, value: 6 },
            { day: 4, hour: 13, value: 0 },
            { day: 4, hour: 14, value: 2 },
            { day: 4, hour: 15, value: 9 },
            { day: 4, hour: 16, value: 0 },
            { day: 4, hour: 17, value: 4 },
            { day: 4, hour: 18, value: 3 },
            { day: 4, hour: 19, value: 0 },
            { day: 4, hour: 20, value: 1 },
            { day: 4, hour: 21, value: 4 },
            { day: 4, hour: 22, value: 0 },
            { day: 4, hour: 23, value: 2 },
            { day: 4, hour: 24, value: 6 },
            { day: 5, hour: 1, value: 0 },
            { day: 5, hour: 2, value: 3 },
            { day: 5, hour: 3, value: 8 },
            { day: 5, hour: 4, value: 0 },
            { day: 5, hour: 5, value: 1 },
            { day: 5, hour: 6, value: 7 },
            { day: 5, hour: 7, value: 0 },
            { day: 5, hour: 8, value: 2 },
            { day: 5, hour: 9, value: 6 },
            { day: 5, hour: 10, value: 0 },
            { day: 5, hour: 11, value: 2 },
            { day: 5, hour: 12, value: 13 },
            { day: 5, hour: 13, value: 0 },
            { day: 5, hour: 14, value: 2 },
            { day: 5, hour: 15, value: 5 },
            { day: 5, hour: 16, value: 0 },
            { day: 5, hour: 17, value: 1 },
            { day: 5, hour: 18, value: 9 },
            { day: 5, hour: 19, value: 0 },
            { day: 5, hour: 20, value: 1 },
            { day: 5, hour: 21, value: 8 },
            { day: 5, hour: 22, value: 0 },
            { day: 5, hour: 23, value: 3 },
            { day: 5, hour: 24, value: 8 },
            { day: 6, hour: 1, value: 0 },
            { day: 6, hour: 2, value: 2 },
            { day: 6, hour: 3, value: 10 },
            { day: 6, hour: 4, value: 0 },
            { day: 6, hour: 5, value: 1 },
            { day: 6, hour: 6, value: 11 },
            { day: 6, hour: 7, value: 1 },
            { day: 6, hour: 8, value: 3 },
            { day: 6, hour: 9, value: 10 },
            { day: 6, hour: 10, value: 0 },
            { day: 6, hour: 11, value: 0 },
            { day: 6, hour: 12, value: 7 },
            { day: 6, hour: 13, value: 0 },
            { day: 6, hour: 14, value: 3 },
            { day: 6, hour: 15, value: 15 },
            { day: 6, hour: 16, value: 0 },
            { day: 6, hour: 17, value: 1 },
            { day: 6, hour: 18, value: 12 },
            { day: 6, hour: 19, value: 0 },
            { day: 6, hour: 20, value: 1 },
            { day: 6, hour: 21, value: 12 },
            { day: 6, hour: 22, value: 0 },
            { day: 6, hour: 23, value: 3 },
            { day: 6, hour: 24, value: 11 },
            { day: 7, hour: 1, value: 0 },
            { day: 7, hour: 2, value: 1 },
            { day: 7, hour: 3, value: 4 },
            { day: 7, hour: 4, value: 0 },
            { day: 7, hour: 5, value: 0 },
            { day: 7, hour: 6, value: 7 },
            { day: 7, hour: 7, value: 0 },
            { day: 7, hour: 8, value: 1 },
            { day: 7, hour: 9, value: 12 },
            { day: 7, hour: 10, value: 0 },
            { day: 7, hour: 11, value: 1 },
            { day: 7, hour: 12, value: 6 },
            { day: 7, hour: 13, value: 0 },
            { day: 7, hour: 14, value: 1 },
            { day: 7, hour: 15, value: 8 },
            { day: 7, hour: 16, value: 0 },
            { day: 7, hour: 17, value: 3 },
            { day: 7, hour: 18, value: 3 },
            { day: 7, hour: 19, value: 0 },
            { day: 7, hour: 20, value: 0 },
            { day: 7, hour: 21, value: 8 },
            { day: 7, hour: 22, value: 0 },
            { day: 7, hour: 23, value: 3 },
            { day: 7, hour: 24, value: 10 }
        ];

        var humanPieData = [
            { label: "> 3 Days", count: 13 },{ label: "1 - 5 Days", count: 91 }, { label: "< a Day", count: 0 },{ label: "< 1 Hour", count: 44 }, { label: "< 30 seconds", count: 2 } 
        ];
        var botPieData = [
            { label: "> 3 Days", count: 2 }, { label: "1 - 5 Days", count: 4 }, { label: "< a Day", count: 1 }, { label: "< 1 Hour", count: 2 }, { label: "< 30 seconds", count: 60 }
        ];

        var humanBarData = [
        { letter: "Jan", frequency: 52 },
        { letter: "Feb", frequency: 58 },
        { letter: "Mar", frequency: 101 },
        { letter: "Apr", frequency: 25 },
        { letter: "May", frequency: 30 },
        { letter: "June", frequency: 23 },
        { letter: "July", frequency: 31 },
        { letter: "Aug", frequency: 26 },
        { letter: "Sept", frequency: 36 },
        { letter: "Oct", frequency: 40 },
        { letter: "Nov", frequency: 50 },
        { letter: "Dec", frequency: 84 }
        ];
        var botBarData = [
            { letter: "Jan", frequency: 4 },
            { letter: "Feb", frequency: 5 },
            { letter: "Mar", frequency: 1 },
            { letter: "Apr", frequency: 252 },
            { letter: "May", frequency: 301 },
            { letter: "June", frequency: 9 },
            { letter: "July", frequency: 7 },
            { letter: "Aug", frequency: 24},
            { letter: "Sept", frequency: 3 },
            { letter: "Oct", frequency: 17 },
            { letter: "Nov", frequency: 11 },
            { letter: "Dec", frequency: 2 }
        ];
    </script>

</asp:Content>
