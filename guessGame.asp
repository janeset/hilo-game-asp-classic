<!DOCTYPE html>
<!--/*
* FILE : guessGame.asp
* PROJECT : PROG2001 - Assignment #4
* PROGRAMMER : Janeth Santos
* FIRST VERSION : october 28, 2020
* DESCRIPTION :
* ASP file that will ask user for their guess number
* input, which is validated in the ASP webserver.
* Validation consists of the number being a positive integer.
* The user wins the game when their guess number matches the winner number.
*/-->
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Hi-Lo game | Guess the number</title>
     <link rel="stylesheet" href="./css/hiloGame.css">

     <style>

     body {
           background: url(img/1.jpg) no-repeat center center fixed;    /* The image used */
           background-color: #cccccc;       /* Used if the image is unavailable */
           background-size: cover;          /* Resize the background image to cover the entire container */
           background-origin: boder-box;
           font-family: sans-serif;
           }
   </style>

    <script type="text/javascript">
    // -----------------------------------------------------------------------------
    // FUNCTION : validNumber()
    // DESCRIPTION :
    // This function validates the number input in the webpage
    // is not blank.
    // PARAMETERS : none
    // RETURNS : shouldSubmit
    // -----------------------------------------------------------------------------
      function validNumber()
      {
        var shouldSubmit = true
        var whichNumber = document.getElementById("numberGuessBox").value;

        if ((whichNumber.trim()).length == 0)
        {
          document.getElementById("numGuessError").innerHTML = "Guess Number can <b>NOT</b> be blank";
          shouldSubmit = false;
        }
        else
        {
            document.getElementById("numGuessError").innerHTML = "";
        }
        return shouldSubmit
      }
    </script>



  <%  '----------------------------------------------------------------------------
  'FUNCTION : validateGuessNumber(inputNumber)
  'DESCRIPTION :
  'This function validates the input for the  Guess number withing the set range,
  ' the valid input must be a positive integer within the min and max range
  'PARAMETERS : inputNumber
  'RETURNS :errorMsg
  '-----------------------------------------------------------------------------
  Function validateGuessNumber(inputNumber)
      dim errorMsg
      dim min
      dim max
      min = request.cookies("cMinNumber")
      max = request.cookies("cMaxNumber")
          'field is not empty, now check if input is a number
          if IsNumeric(inputNumber) then
           'check is an int and not a floating number'
              set oRE = new RegExp

              with oRE
                  .Pattern  = "^-?[0-9]+$"
                  .IgnoreCase = false
                  .Global = false
              End with

                  if oRE.Test(inputNumber) Then
                      ' its an int, is it greater than 1?
                      inputNumber = CInt(inputNumber)
                      min = Cint(min)
                      max = Cint(max)
                          If (inputNumber >= min AND inputNumber <= max) Then
                          errorMsg = "validNumber"
                          Else
                          errorMsg = "Sorry, eh! the Number must be between " & min & " and " & max
                          End If
                  Else ' not an Integer
                  errorMsg = "Sorry, eh! only Integer numbers allowed"
                  End If
          Else
          errorMsg = "Sorry, eh! only Numeric values allowed"
          End If
  validateGuessNumber = errorMsg
  end function
  %>

  <%
  '----------------------------------------------------------------------------
  'FUNCTION : guessWinnerNumber(inputNumber)
  'DESCRIPTION :
  'This function validates if the guess number matches the winner number
  ' if they match the user wins the game, else the range is adjusted accordingly
  ' and updated.
  'PARAMETERS : inputNumber
  'RETURNS :rangeMsg
  '-----------------------------------------------------------------------------
    'determine if guess is correct
    Function guessWinnerNumber(inputNumber)
      dim min
      dim max
      dim guess
      dim winner
      dim rangeMsg
      min = request.cookies("cMinNumber")
      max = request.cookies("cMaxGuessNumber")
      winner = request.cookies("cWinnerNum")
      guess = inputNumber

      'convert to integer
      min = Cint(min)
      max = Cint(max)
      guess = Cint(guess)
      winner = Cint(winner)

        if (guess = winner) Then
              response.Redirect("winner.asp")
        elseif (guess > winner AND guess < max ) Then
            max = guess + 1
            response.cookies("cMaxNumber") = max    'update max number in cookies
        elseif (guess > 0 AND guess < winner) Then
            min = guess + 1
            response.cookies("cMinNumber") = min    'update min number in cookies
        elseif (guess = max) then
            max = guess - 1
            response.cookies("cMaxNumber") = max    'update max number in cookies
        end if

          rangeMsg = "Your allowed range is between " & min & " and " & max
    guessWinnerNumber = rangeMsg
    end function
    %>



</head>
<body>

<%
' Variables
dim name
dim maxGuessNumber
dim minGuessNumber
dim winnerNum
dim guessNum

'name
if ( name = "") then
    name = request.cookies("cInputName")                        'restore name from cookies'
end if

'MAX GUESS
if ( maxGuessNumber <> "") then
  maxGuessNumber = request.cookies("cMaxGuessNumber")           'restore number from cookies'
  else
  maxGuessNumber = request.cookies("cMaxNumber")
  response.cookies("cMaxGuessNumber") = maxGuessNumber
end if

'MINIMUN NUMBER'
if ( minGuessNumber <> "") then                                 'initialize min number
  minGuessNumber = request.cookies("cMinGuessNumber")
else
  minGuessNumber = request.cookies("cMinNumber")
  response.cookies("cMinGuessNumber") = minGuessNumber
end if

'WINNER NUMBER'

if ( winnerNum = "") then
    winnerNum = request.cookies("cWinnerNum")                   'initialize winner number
end if

'GUESS NUMBER'
guessNum = request.Form("guessNumInput")                  'represents the guessNumber input
if (guessNum = "") Then
   response.cookies("cGuessNumber") = guessNum           'preserve guessNumber in cookie
end if
dim rangeMsg
if rangeMsg = "" Then                                     'update range
   rangeMsg = "Your allowed range is between " & minGuessNumber & " and " & maxGuessNumber
end if
%>

<%
if (guessNum <> "") then  'we got some value in guessNum'

  dim errorMsg

  errorMsg = validateGuessNumber(guessNum)

    if ( errorMsg = "validNumber") Then   'valid input'
        errorMsg = ""                     'clear error msg
       rangeMsg = guessWinnerNumber(guessNum)     'update range

    end if
Else
  errorMsg = ""

end if
%>

<form name="hiloGuessNumForm" action="./guessGame.asp" onSubmit= "return validNumber();" method="POST"  autocomplete="off">

<div class="login-box" >
        <h1 class="neon blue" style="font-size: 3em">HiLo Game </h1>
        <h4 class="neon blue">Hey! <%=name%></h4>
        <h5 class="neon green"><%=rangeMsg%></h5>
          <div class="user-box">
              <label> Please Enter a guess number</label><br><br>
              <input id="numberGuessBox" name="guessNumInput" type="text"  placeholder="e.g 7" style="text-align: center; color: pink">
          </div>
  <div id="numGuessError" style=" font-family:calibri; color:orange; text-align:center;"><%=errorMsg%></div><br>
  <button class="button" type="submit" >Make this Guess</button>


</div>

</form>


</body>
</html>
