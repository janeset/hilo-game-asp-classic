<!DOCTYPE html>
<!--/*
* FILE : maxNumber.asp
* PROJECT : PROG2001 - Assignment #4
* PROGRAMMER : Janeth Santos
* FIRST VERSION : october 28, 2020
* DESCRIPTION :
* ASP file that will ask user for their max number
* input is validated in the ASP webserver.
* Validation consists of the number being a positive integer.
*/-->
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Hi-Lo game | Max Number </title>

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

    <!-- client validation -->
    <script type="text/javascript">
      // -----------------------------------------------------------------------------
      // FUNCTION : validateNumber()
      // DESCRIPTION :
      // This function validates the number input in the webpage
      // is not blank.
      // PARAMETERS : none
      // RETURNS : shouldSubmit
      // -----------------------------------------------------------------------------
      function validateNumber()
      {
        var shouldSubmit = true
          whichNumber = document.getElementById("numberInputBox").value;


        if ((whichNumber.trim()).length == 0)
        {
          document.getElementById("maxNumberError").innerHTML = "Number can <b>NOT</b> be blank";
          shouldSubmit = false;
        }
        else
        {
            document.getElementById("maxNumberError").innerHTML = "";
        }
        return shouldSubmit
      }

    </script>

<%

'----------------------------------------------------------------------------
'FUNCTION : validateMaxNumber(inputNumber)
'DESCRIPTION :
'This function validates the input for the  MAX number (used in the guessing
' range), if validation is sucessfull  it will proceed to the next Guess Game
' and generate the winning number to guess, the valid input must be a positive integer
'PARAMETERS : inputNumber
'RETURNS :errorMsg
'-----------------------------------------------------------------------------
  Function validateMaxNumber(inputNumber)
      dim errorMsg
      dim winnerNumer
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
                          If inputNumber > 1 Then
                            winnerNumber = ranNumber(inputNumber)
                            response.cookies("cWinnerNum") = winnerNumber
                            response.cookies("cMinNumber") = 1
                            errorMsg = "validNumber"
                          Else
                            errorMsg = "Sorry, eh! the Number must be greater than 1 "
                          End If
                  Else ' not an Integer
                  errorMsg = "Sorry, eh! only Integer numbers allowed"
                  End If
          Else
          errorMsg = "Sorry, eh! only Numeric values allowed"
          End If
  validateMaxNumber = errorMsg
end function
%>


<%
'----------------------------------------------------------------------------
'FUNCTION : ranNumber()
'DESCRIPTION :
'This function 'generate a random winner Number within a range between min num
' and valid max number
' original source:  https://www.w3schools.com/asp/func_rnd.asp
'PARAMETERS : valid maxNumber
'RETURNS :randomNumber
'-----------------------------------------------------------------------------

      Function ranNumber(maxNumber)
          dim minNum
          dim randomNumber
          minNum = 1

          Randomize
          randomNumber = Int((maxNumber - minNum + 1) * Rnd + minNum)

      ranNumber = randomNumber
    end function
    %>

</head>


<body>



<%
'declare variables
dim name
dim maxNum
name = request.Form("nameInput")                'represents the user's name
if ( name <> "") then
  response.cookies("cInputName")= name          'preserve name in cookies
Else
    name = request.cookies("cInputName")        'restore name from cookies'
end if

maxNum = request.Form("numberInput")            'represents the maxNumber input
if (maxNum <> "") Then
  response.cookies("cMaxNumber") = maxNum       'preserve maxNumber in cookie
end if

%>

<%
if (maxNum <> "") then  'we got some value in maxNum'

  dim errorMsg
  errorMsg = validateMaxNumber(maxNum)

    if ( errorMsg = "validNumber") Then
       errorMsg = ""                         'clear error msg
       response.Redirect("guessGame.asp")    'go to next page
    end if
Else
  errorMsg = ""
  response.cookies("cWinnerNum") = ""
end if
%>

<form name="hiloMaxNumForm" action="./maxNumber.asp" onSubmit= "return validateNumber();" method="POST"  autocomplete="off">
<div class="login-box" >
  <h1 class="neon blue" style="font-size: 3em">HiLo Game </h1>
  <h4 class="neon blue">Hello! <%=name%></h4>
    <div class="user-box">
      <label> Please Enter a Max guess number</label><br><br>
      <input id="numberInputBox" name="numberInput" type="text" placeholder="e.g 100" style="text-align: center; color: pink">
    </div>
  <div id="maxNumberError" style=" font-family:calibri; color:orange; text-align:center;"><%=errorMsg%></div><br>
  <button class="button"  type="submit">Submit number</button>
</div>

  </form>
</body>

</html>
