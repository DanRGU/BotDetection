<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BotDetection._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        $(function () {  // Declare a proxy to reference the hub. 
            var update = $.connection.updateHub;

            // Start the connection.
            $.connection.hub.start().done(function () { Console.Log("Working"); });
        });
    </script>

    <div id="inputContainer">

        <asp:Panel ID="Panel1" runat="server" DefaultButton="userSubmit">
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <asp:TextBox runat="server" ID="userInput" defaultbutton="userSubmit" />
                    <asp:LinkButton runat="server" ID="userSubmit" OnClick="submitButton_Clicked" OnClientClick="return myFunction();"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></asp:LinkButton>

                    <asp:TextBox runat="server" ID="twitterOutput" TextMode="MultiLine" ReadOnly="true" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </asp:Panel>

        <div class="chart">
        </div>

    </div>
</asp:Content>
