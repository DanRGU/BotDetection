﻿<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BotDetection._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div id="inputContainer">
            <asp:TextBox runat="server" ID="userInput" />
            <asp:LinkButton ID="userSubmit" runat="server" OnClick="submitButton_Clicked"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></asp:LinkButton>
        </div>

        <asp:TextBox runat="server" ID="twitterOutput" Text="" />

</asp:Content>
