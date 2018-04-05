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
            <h3 id="heatCompareTitle">Example Heatmap of Bot Tweets</h3>
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
                <h3 id="pieCompareTitle">Example Pie Chart of Bot Retweet times</h3>

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
                <h3 id="barCompareTitle">Example Bar Chart of Bot Tweet Frequency</h3>
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
    <div class="sentimentChart row">
        <div class="innerSentimentChart col-md-6"> 
            <h3>Sentiment of User Tweets</h3>
        </div>
            <div class="innerSentimentChart2 col-md-6">
                <h3 id="sentimentCompareTitle">Example Sentiment Chart of Bot Tweets</h3>
                <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="compareButtons">
                        <button id="humanSentimentChart" type="button" class="btn btn-info" onclick="drawHumanSentimentChart();">Human</button>
                        <button id="botSentimentChart" type="button" class="btn btn-info" onclick="drawBotSentimentChart();">Bot</button>
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
      //  var SentimentChartDataReload = botSentimentData;


        //Setting the div sizes based on window size
        $(function () {
            $('.sentimentChart, .pieChart, .heatMap, .barChart, #MainContent_ctl00').css({ height: $(window).innerHeight() });
            $('.sentimentChart, .pieChart, .heatMap, .barChart, #MainContent_ctl00').css({ width: $(window).innerWidth() });
            $(window).resize(function () {
                $('.sentimentChart, .pieChart, .heatMap, .barChart, #MainContent_ctl00').css({ height: $(window).innerHeight() });
            });
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
               // url: "/GetTweets.asmx/GetTwitterDataJSON",
                url: "https://botdetectionmanual.azurewebsites.net/GetTweets.asmx/GetTwitterDataJSON",
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

                        drawPieChart(pieChartData, ".innerPieChart");
                        drawPieChart(botPieData, ".innerPieChart2");

                        drawBarChart(barChartData, ".innerBarChart");
                        drawBarChart(botBarData, ".innerBarChart2");

                        drawSentimentChart(sentimentData, ".innerSentimentChart");
                        drawSentimentChart(humanSentimentData, ".innerSentimentChart2");

                       

                    }
                    

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

                drawSentimentChart(sentimentData, ".innerSentimentChart");
                drawSentimentChart(sentimentData, ".innerSentimentChart2");
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
            $("#barCompareTitle").html("Example Bar Chart of Bot Tweet Frequency");
            drawBarChart(botBarData, ".innerBarChart2");
            pieChartDataReload = botBarData;
        }
        function drawHumanBarChart() {
            $("#barCompareTitle").html("Example Bar Chart of Human Tweet Frequency");
            drawBarChart(humanBarData, ".innerBarChart2");
            barChartDataReload = humanBarData;
        }

        //Bar Chart
        function drawBotSentimentChart() {
            $("#sentimentCompareTitle").html("Example Sentiment Chart of Bot Tweets");
            drawSentimentChart(botSentimentData, ".innerSentimentChart2");
            sentimentChartDataReload = sentimentBarData;
        }
        function drawHumanSentimentChart() {
            $("#sentimentCompareTitle").html("Example Sentiment Chart of Human Tweets");
            drawSentimentChart(humanSentimentData, ".innerSentimentChart2");
            sentimentChartDataReload = humanSentimentData;
        }


       

    </script>

</asp:Content>
