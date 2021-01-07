<!DOCTYPE html>
<!--/*
* FILE : winner.asp
* PROJECT : PROG2001 - Assignment #4
* PROGRAMMER : Janeth Santos
* FIRST VERSION : october 28, 2020
* DESCRIPTION :
* ASP file that will clear all cookies used (except the name of the user)
* and display a winner message for the user,
* offering them a chance to play again
*/-->
<html lang="en" dir="ltr">
<head>
    <meta charset="utf-8">
    <title>Hi-Lo game | Winner! </title>

    <link rel="stylesheet" href="./css/winner.css">

  <style>

    body {
      background: url(img/3.jpg) no-repeat center center fixed;    /* The image used */
      background-color: #cccccc;       /* Used if the image is unavailable */
      background-size: cover;          /* Resize the background image to cover the entire container */
      background-origin: boder-box;
      font-family: sans-serif;
      }
  </style>

    <%
    '----------------------------------------------------------------------------
    'FUNCTION : playAgain()
    'DESCRIPTION :
    'This function clears all cookies except the name of the user
    'RETURNS : nothing
    '-----------------------------------------------------------------------------
      Function playAgain()
        response.cookies("cMaxGuessNumber") = ""
        response.cookies("cMinGuessNumber") = ""
        response.cookies("cMinNumber") = ""
        response.cookies("cMaxNumber") = ""
        response.cookies("cGuessNumber") = ""
        response.cookies("cWinnerNum")= ""

    end function
    %>

</head>



<body>

  <%  playAgain() %>

  <form name="hiloMaxNumForm" action="./maxNumber.asp"  method="POST"  autocomplete="off" >
    <div class="container">
      <h1 class="neon blue "style="font-size: 3em">  You Win!</h1>
      <h1 class="neon green" style="font-size: 2em">  You Guessed the number!</h1>
      <button class="buttonWin bGlow" type="submit" value="Play Again">Play again</button>
    </div>

  </form>




</body>
</html>
