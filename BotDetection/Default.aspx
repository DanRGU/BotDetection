<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BotDetection._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div id="inputContainer">
            <input type="text" id="userInput" placeholder="@username"/>
            <button type ="submit" id="userSubmit"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
    </div>
</asp:Content>
