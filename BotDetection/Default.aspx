<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BotDetection._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">

        function getData() {

            var dataParam = $("#userInput").val();


            //$.post("GetTweets.asmx/GetTwitterDataJSON", { userID: data }, "application/json; charset=utf-8")
            //    .done(function (response) {
            //        $("#twitterOutput").val(response);
            //    });

            $.ajax({
                url: "GetTweets.asmx/GetTwitterDataJSON",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{ 'userID': '"+dataParam+"' }",
                success: function (response) {
                    $("#twitterOutput").val(JSON.stringify(response));
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
