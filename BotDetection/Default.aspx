<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BotDetection._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        console.log("test");
        $(function () {
            // Declare a proxy to reference the hub. 
            var update = $.connection.updateHub;
            // Create a function that the hub can call to broadcast messages.
            update.client.updateClients = function (tweetLengths) {

                var data = tweetLengths;

                d3.select(".chart")
                    .selectAll("div")
                    .data(data)
                    .enter()
                    .append("div")
                    .style("width", function (d) { return d + "px"; })
                    .text(function (d) { return d; });
            };
            // Start the connection.
            $.connection.hub.start().done(function () {
                console.log("working");
            });
        });
    </script>

    <div id="inputContainer">

        <asp:Panel ID="Panel1" runat="server" DefaultButton="userSubmit">
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <asp:TextBox runat="server" ID="userInput" defaultbutton="userSubmit" />
                    <asp:LinkButton runat="server" ID="userSubmit" OnClick="submitButton_Clicked" OnClientClick="return myFunction();"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></asp:LinkButton>
                    <div id="errorContainer">
                        <asp:RequiredFieldValidator 
                            ID="userValidate" 
                            ErrorMessage="Please enter a username" 
                            ControlToValidate="userInput"
                            runat="server">
                        </asp:RequiredFieldValidator>
                    </div>
                    <asp:TextBox runat="server" ID="twitterOutput" TextMode="MultiLine" ReadOnly="true" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </asp:Panel>

        <div class="chart">
        </div>

    </div>
</asp:Content>
