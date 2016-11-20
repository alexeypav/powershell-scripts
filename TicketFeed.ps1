#Get latest gmail emails and output in HTML Table
#AlexeyP 2016

#Set Variables
$username = "username@googleappsdomain.com"
$password = "password"

#Number of emails to show
$NumberOfEntries = 9

$time = get-date -Format t

#Connect to gmail using webclient, using https://mail.google.com/mail/feed/atom 
function get-emails($a, $b){

    $webclient = new-object System.Net.WebClient
    $webclient.Credentials = new-object System.Net.NetworkCredential ("$a","$b")
    [xml]$xml= $webclient.DownloadString("https://mail.google.com/mail/feed/atom")
    $xml

}


[xml]$xml = get-emails $username $password
 

$Tickets = @{}
 
 
function check-latestticket {
 
    [datetime]$1stTime = $xml.feed.entry[0].modified
 
    if($1stTime -gt (Get-Date).AddMinutes("-10")){
        $true
    }else{
        $false
    }
}
 
#Outputs an html table with added variables from section above
function html-display {
 
    #Put a flashing alert if latest email less than 5minutes old
    if (check-latestticket -eq $true){
 
         "<section class=`"contact-info`">
          <span class=`"blink`" style=`"color:red`">New Ticket:" + $xml.feed.entry[0].title + "</span>
       </section>"
 
 
    }else{
    '<section class="contact-info">
          <span class="blink"></span>
       </section>'
 
 
    }
 
 
    "<table border=1 frame=void rules=rows >
  <colgroup><col/><col/><col/><col/><col/><col/></colgroup>
  <tr><th>Title</th><th>Summary</th><th>From</th><th>When</th></tr>"
 
   foreach ($number in 0..($NumberOfEntries -1))
    {
        if ($xml.feed.entry[$number].summary.length -lt 80)
        {
            $summary = $xml.feed.entry[$number].summary
        }
        else
        {
            $summary = $xml.feed.entry[$number].summary.substring(0,80) + "..."
        }
 
        "<tr><td>" + $xml.feed.entry[$number].title + "</td><td>" + $summary + "</td><td>" + $xml.feed.entry[$number].author.name + "</td><td>" + ([datetime]$xml.feed.entry[$number].modified).ToString("dddd dd/MM/yy hh:mm tt") + "</td></tr>"
 
    }
   
   "</table>
    
        <br><br><br><br>
    <div align=`"center`">
  Current Time: $time
</div>
    
    "
 
}
 
 
#Output html
html-display