﻿<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BotDetection._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        function getData() {

            $.ajax({
                type: "POST",
                url: "Default.aspx/submitButton_Clicked",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $("#twitterOutput").text(response.d);
                },
                failure: function () {
                    alert("Error");
                }
            });

        }

    </script>

    <div id="inputContainer">

        <asp:Panel ID="Panel1" runat="server" DefaultButton="userSubmit">
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div id="submission">
                        <asp:TextBox runat="server" ID="userInput" defaultbutton="userSubmit" />
                        <asp:LinkButton runat="server" ID="userSubmit" OnClientClick="getData()"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></asp:LinkButton>
                    </div>
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
