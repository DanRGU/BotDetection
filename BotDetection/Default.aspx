<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BotDetection._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        var data = [];

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
                    var tweets = response.d;
                    var data = [];
                    for (var i in tweets) {

                        var tweet = tweets[i];
                        $("#twitterOutput").append(tweet["Content"] + "\n Length: " + tweet["Content"].length + "\n\n");
                        data.push(tweet["Content"].length);

                    }
                    
                    
                    d3.select(".chart")
                        .selectAll("div")
                        .data(data)
                        .enter()
                        .append("div")
                        .style("width", function (d) { return d * 2 + "px"; })
                        .text(function (d) { return d; });

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
        </div>

    </div>
</asp:Content>
