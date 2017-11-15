<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
    <%@ page isELIgnored="false"%>
        <!DOCTYPE html>
        <html>
      <head>
            <title>DECIBEL</title>
            <meta charset="utf-8" />
            <script type="text/javascript" src="https://public.tableau.com/javascripts/api/tableau-2.min.js"></script>
            <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
            <script src="<spring:url value=" ${pageContext.request.contextPath}/resources/scripts/require.min.js " />"></script>
            <script src="<spring:url value=" ${pageContext.request.contextPath}/resources/scripts/jquery.min.js " />"></script>
            <script src="<spring:url value=" ${pageContext.request.contextPath}/resources/scripts/speech.browser.sdk-min.js " />"></script>
            <script src="<spring:url value=" ${pageContext.request.contextPath}/resources/scripts/speech.browser.sdk.js " />"></script>
        </head>
     <body>

            <img src="${pageContext.request.contextPath}/resources/images/deloitte-logo-print.png" class="logo_deloitte" alt="Deloitte" style="z-index:999;">
            <img src="${pageContext.request.contextPath}/resources/images/Decibel.png" class="logo_decibel" alt="Decibel" height="60px" Width="180px" style="z-index:999;">
            <h2 class="head1"> Voice Enabled </h2>
            <h2 class="head2"> Cognitive </h2>
            <h2 class="head3"> Platform </h2>

            <img src="${pageContext.request.contextPath}/resources/images/mic.png" id="speakAgainsmall" class="sabutton" hidden="" title="Click to speak again">
            <img src="${pageContext.request.contextPath}/resources/images/bgfinal.png">
            <div class="speak-home">
                <button id="startBtn" class="stbutton" disabled="disabled" hidden="">Start</button>
                <button id="stopBtn" class="spbutton" disabled="disabled" hidden="">Stop</button>
                <div><img src="${pageContext.request.contextPath}/resources/images/mic.png" id="speakAgainbig" alt="Mic" class="mic" title="Click to speak again"> </div>
            </div>

            <div style="float: center;margin-top: 90px;margin-left: 40px;">
                <table style="width:100px">
                    <tr>
                        <td><input type="hidden" id="key" type="text" size="40" value="da516ce671ae4a9da60cb67eac9c14e7"></td>
                    </tr>

                    <tr>
                        <td></td>
                        <td>
                            <button id="startBtn" disabled="disabled" hidden="">Start</button>
                            <button id="stopBtn" disabled="disabled" hidden="">Stop</button>

                        </td>
                    </tr>
                </table>
            </div>
            <div id="vizContainer" style="width:1000px; height:350px; margin-top: 15px;margin-left: 21px;">
            </div>
            <div>
                <div id="toggle-first-sidebar" style="text-align: right;position: absolute;width: 100%;right: 18px;top: 200px;cursor: pointer;">
                    <img src="${pageContext.request.contextPath}/resources/images/plus.png" width="30px" height="30px">
                    <div class="first-sidebar-content" style="display: none; min-width: 200px">
                        <div style="min-width: 300px;float: right;background-color: #fff;text-align: center;">

                            <div>Recognized voice: <span id="hypothesisDiv"></span></div>
                            <br>
                            <br>
                            <br>
                            <br>
                        </div>
                    </div>
                </div>
                <div id="toggle-second-sidebar" style="text-align: right;position: absolute;width: 100%;right: 18px;top: 400px;cursor: pointer;">
                    <img src="${pageContext.request.contextPath}/resources/images/plus.png" width="30px" height="30px">
                    <div class="second-sidebar-content" style="display: none; min-width:200px">
                        <div style="min-width: 300px; float: right;background-color: #fff;text-align: center;">
                            <div>

                                <textarea id="phraseDiv" style="width:300px;height:100px"></textarea>
                            </div>

                            <div> Status: <span id="statusDiv"></span></div>
                            <br>
                            <br>
                        </div>
                    </div>
                </div>
            </div>
              <!-- SDK USAGE -->
    <script>
        // On doument load resolve the SDK dependecy
        function Initialize(onComplete) {
            require(["Speech.Browser.Sdk"], function(SDK) {
                onComplete(SDK);
            });
        }
        
        // Setup the recongizer
        function RecognizerSetup(SDK, recognitionMode, subscriptionKey) {
        	console.log('subscriptionKey+++'+ subscriptionKey);
            var recognizerConfig = new SDK.RecognizerConfig(
                new SDK.SpeechConfig(
                    new SDK.Context(
                        new SDK.OS(navigator.userAgent, "Browser", null),
                        new SDK.Device("SpeechSample", "SpeechSample", "1.0.00000"))),
                recognitionMode
                ); 

           
            var authentication = new SDK.CognitiveSubscriptionKeyAuthentication(subscriptionKey);
         	console.log('authentication+++'+ authentication);
            return SDK.CreateRecognizer(recognizerConfig, authentication);
        }

        // Start the recognition
        function RecognizerStart(SDK, recognizer) {
            recognizer.Recognize((event) => {
                /*
                 Alternative syntax for typescript devs.
                 if (event instanceof SDK.RecognitionTriggeredEvent)
                */
                console.log('event.Name+++' + event.Name);
                switch (event.Name) {
                    case "RecognitionTriggeredEvent" :
                        UpdateStatus("Initializing");
                        break;
                    case "ListeningStartedEvent" :
                        UpdateStatus("Listening");
                        break;
                    case "RecognitionStartedEvent" :
                        UpdateStatus("Listening_Recognizing");
                        break;
                    case "SpeechStartDetectedEvent" :
                        UpdateStatus("Listening_DetectedSpeech_Recognizing");
                        console.log(JSON.stringify(event.Result)); // check console for other information in result
                        break;
                    case "SpeechHypothesisEvent" :
                        UpdateRecognizedHypothesis(event.Result.Text);
                        console.log(JSON.stringify(event.Result)); // check console for other information in result
                        break;
                    case "SpeechEndDetectedEvent" :
                        OnSpeechEndDetected();
                        UpdateStatus("Processing_Adding_Final_Touches");
                        console.log(JSON.stringify(event.Result)); // check console for other information in result
                        break;
                    case "SpeechSimplePhraseEvent" :
                        UpdateRecognizedPhrase(JSON.stringify(event.Result, null, 3));
                        break;
                    case "SpeechDetailedPhraseEvent" :
                        UpdateRecognizedPhrase(JSON.stringify(event.Result, null, 3));
                        break;
                    case "RecognitionEndedEvent" :
                        OnComplete();
                        UpdateStatus("Idle");
                        console.log(JSON.stringify(event)); // Debug information
                        break;
                }
            })
            .On(() => {
                // The request succeeded. Nothing to do here.
            },
            (error) => {
                console.error(error);
            });
        }

        // Stop the Recognition.
        function RecognizerStop(SDK, recognizer) {
            // recognizer.AudioSource.Detach(audioNodeId) can be also used here. (audioNodeId is part of ListeningStartedEvent)
            recognizer.AudioSource.TurnOff();
        }
    </script>

    <!-- Browser Hooks -->
    <script>
        var startBtn, stopBtn, hypothesisDiv, phraseDiv, statusDiv, key, languageOptions, formatOptions;
        var SDK;
        var recognizer;
        var previousSubscriptionKey;
        var input;
        var voices = speechSynthesis.getVoices();
        document.addEventListener("DOMContentLoaded", function () {
            createBtn = document.getElementById("createBtn");
            startBtn = document.getElementById("startBtn");
            stopBtn = document.getElementById("stopBtn");
            phraseDiv = document.getElementById("phraseDiv");
            hypothesisDiv = document.getElementById("hypothesisDiv");
            statusDiv = document.getElementById("statusDiv");
            key = document.getElementById("key");
         

            startBtn.addEventListener("click", function () {
                if (!recognizer || previousSubscriptionKey != key.value) {
                    previousSubscriptionKey = key.value;
                    Setup();
                }

                hypothesisDiv.innerHTML = "";
                phraseDiv.innerHTML = "";
                RecognizerStart(SDK, recognizer);
                startBtn.disabled = true;
                stopBtn.disabled = false;
            });
			
			speakAgainsmall.addEventListener("click", function () {
                if (!recognizer || previousSubscriptionKey != key.value) {
                    previousSubscriptionKey = key.value;
                    Setup();
                }

                hypothesisDiv.innerHTML = "";
                phraseDiv.innerHTML = "";
                RecognizerStart(SDK, recognizer);
                startBtn.disabled = true;
                stopBtn.disabled = false;
            });
			
			speakAgainbig.addEventListener("click", function () {
                if (!recognizer || previousSubscriptionKey != key.value) {
                    previousSubscriptionKey = key.value;
                    Setup();
                }

                hypothesisDiv.innerHTML = "";
                phraseDiv.innerHTML = "";
                RecognizerStart(SDK, recognizer);
                startBtn.disabled = true;
                stopBtn.disabled = false;
            });

            stopBtn.addEventListener("click", function () {
                RecognizerStop(SDK);
                startBtn.disabled = false;
                stopBtn.disabled = true;
            });

            Initialize(function (speechSdk) {
                SDK = speechSdk;
                startBtn.disabled = false;
                voiceoutput("Hello! I'm your voice assistant,how can i help you ?",1)
            });
        });
		
        function voiceoutput(text,flag){

            if('speechSynthesis' in window){
			var speech = new SpeechSynthesisUtterance(text);
			speech.lang = 'en-US';
			speech.voice = voices[4]
			window.speechSynthesis.speak(speech);
			if (flag==1)
			{
            setTimeout(activatestart, 4000);
			}
			else if (flag == 2)
			{
			setTimeout(voiceoutput, 10000);
			}
           
			}
        } 
		
        // function voiceoutput_detection(text){

         //   if('speechSynthesis' in window){
		//	var speech = new SpeechSynthesisUtterance(text);
		//	speech.lang = 'en-US';
		//	speech.voice = voices[4]
		//	window.speechSynthesis.speak(speech);
         //   setTimeout(activatestart, 4000);
         //
        //    UpdateRecognizedHypothesisUserConfirmation(text);   
		//	}
        //} 
		
        function activatestart()
        {   
          
            $(startBtn).click() 
            $(startBtn).hide()
            $(stopBtn).hide()
			$(speakAgainsmall).hide()           
        }
		
        function Setup() {
            recognizer = RecognizerSetup(SDK, SDK.RecognitionMode.Interactive, key.value);
        }

        function UpdateStatus(status) {
            statusDiv.innerHTML = status;
        }
		
		
        function UpdateRecognizedHypothesis(text) {
            hypothesisDiv.innerHTML = text;        
            input = text;  
        }
		
        function OnSpeechEndDetected() {
            stopBtn.disabled = true;
        }
		
		var db;
		var fld;
		var val;
		
		
        function UpdateRecognizedPhrase(json) {
        	console.log('json+++' + json);
            $.get("https://westus.api.cognitive.microsoft.com/luis/v2.0/apps/631f2b5e-8875-48f2-984c-9e7e7c78a3e2?subscription-key=c642986d701f44b29227bc3b60fab71b&verbose=true&timezoneOffset=0&q="+input+"",
			//$.get("https://westus.api.cognitive.microsoft.com/luis/v2.0/apps/21b9dd19-9b03-4fb5-87a8-337112c474b7?subscription-key=c642986d701f44b29227bc3b60fab71b&verbose=true&timezoneOffset=0&q="+input+"",
			//$.get("https://westus.api.cognitive.microsoft.com/luis/v2.0/apps/5cac76d5-cdf5-4928-a48e-3fc400c5430a?subscription-key=c642986d701f44b29227bc3b60fab71b&timezoneOffset=0&verbose=true&q="+input+"",
                function(data){
                 phraseDiv.innerHTML =  JSON.stringify(data);
          if (data.entities.length === 0)
					{
						voiceoutput("Please provide a valid input",0); 
						if(viz) {$(speakAgainsmall).show();}
					}
				 else
					{		
						for (var t=0; t < data.entities.length; t++) 
						{	
							if ( data.entities[t].type === "Dashboard" && data.entities.length == 1)
							{ db = data.entities[t].entity; fld = 0; val = 0;}
							else if (data.entities[t].type === "Dashboard" ) 
							{ db = data.entities[t].entity; }
							else if (data.entities[t].type != "builtin.datetimeV2.daterange" &&  data.entities[t].type != "Dashboard" )
							{ fld = data.entities[t].type; val = data.entities[t].entity; } 
						}

						var var1 = dashboardcheck(db);

						if ( var1 === 0 ) 
						{ 
						voiceoutput("Please provide a valid dashboard name",0); 
						if(viz) {$(speakAgainsmall).show();}
						}

						else
						{
						var var2 = fieldcheck(db,fld);
						
							if ( var2 === 0 )
							{
							voiceoutput("Provided dimension does not belong to the dashboard");
							if(viz) {$(speakAgainsmall).show();}
							}
							else
							{
							initViz(db,fld,val,urlvalue);
							}
						}
					}
				 //}
                 //catch(err)
                 //{
                    
                // }
                 //JSON.stringify(data.entities[0].type )+ ":"+ JSON.stringify(data.entities[0].entity);
                });
		}
		
		var urlvalue;
		function dashboardcheck(e) {
			var dbvalue = 0;
			$.ajax({
			async: false,
			dataType : 'json',
			url: "https://sharat543.github.io/POCdashboards.json",
			type : 'GET',
			success: function(data) {
				for (var e1 = 0; e1 < data['dashboards'].length; e1++) {
				if (e === data['dashboards'][e1]['name'])
				{dbvalue = dbvalue + 1; urlvalue = data['dashboards'][e1]['site'];}
				else { dbvalue = dbvalue + 0; }
				}
			}});
			return dbvalue;
		}
		
		function fieldcheck(f1,f2) {
			var fldassign = 0;
			$.ajax({
			async: false,
			dataType : 'json',
			url: "https://sharat543.github.io/POCfields.json",
			type : 'GET',
			success: function(data) {
					for (var f3 = 0; f3 < data['fields'].length; f3++) {
					if (f1 === data['fields'][f3]['db'] && f2 === data['fields'][f3]['name'])
					{fldassign = fldassign + 1;}
					else if (f2 === 0)
					{ fldassign = fldassign + 1; }
					else { fldassign = fldassign + 0; }
					}
			}});
			
			return fldassign;
		}      
	
		var viz,url,sheet,workbook,sharray;
		if (viz) { // If a viz object exists, delete it.
                viz.dispose();
            }
		var counter=0;
		function initViz(d,f,v,u)
		{
			if (viz) { viz.dispose(); }
			viz=0;
            var containerDiv = document.getElementById("vizContainer"),
            options = {
                   	hideTabs: true,
					onFirstInteractive: function () {
									workbook = viz.getWorkbook();
									activeSheet = workbook.getActiveSheet();
									if (activeSheet.getSheetType() === 'dashboard')
									{
									sharray = activeSheet.getWorksheets();
									}
									else
									{
									sharray = null;
									}
									selectfilter(f,v);
									}	
               	      };
			 
			if ( f === 0 )
			{
			voiceoutput("Opening "+d+" dashboard",0);
			}
			else
			{
			voiceoutput("Applying "+v+" filter to "+d+" dashboard",0);
			}
			url = u;
            $('.speak-home').hide();
            
			viz = new tableau.Viz(containerDiv, url, options);

        }
		
		
		function selectfilter(field,value) {
			
			if ( field == 0 && value == 0 )
			{
				viz.revertAllAsync();
				$(speakAgainsmall).show();
			}
			else
			{	
				var derivedvalue = valueCase(value);
				var derivedfield = chooseSelectFilter(field);
				
				if (derivedfield === "select") 
				{ 
					if ( activeSheet.getSheetType() === 'dashboard' )
					{
					for (var i=0; i < sharray.length; i++) { sharray[i].selectMarksAsync(field, derivedvalue, tableau.SelectionUpdateType.REPLACE); } 
					}
					else
					{
					activeSheet.selectMarksAsync(field, derivedvalue, tableau.SelectionUpdateType.REPLACE);
					}
				}
				else if (derivedfield === "filter")
				{
					if ( activeSheet.getSheetType() === 'dashboard' )
					{
					for (var j=0; j < sharray.length; j++) { sharray[j].applyFilterAsync(field, derivedvalue, tableau.FilterUpdateType.REPLACE); }
					}
					else
					{
					activeSheet.applyFilterAsync(field, derivedvalue, tableau.FilterUpdateType.REPLACE);
					}					
				}	
				
				$(speakAgainsmall).show();
			}

				if ( db === "sales distribution")
				{
				voiceoutput("Drug Channel continues to be the leading contributor in your overall sales of $20 Million. The trend on other channels is also inline with the previous periods",2);
				}
				else if ( db === "sales")
				{
				voiceoutput("Product 1 occupies fourth position in terms of market share. and sales have decreased by 0.1 million compared to the previous period",2);
				}
				else if ( db === "incidents")
				{
				voiceoutput("At the start of July, we have 43 incidents, 729 got added to queue and we resolved 718 of them. Currently working on 54 incidents",2);
				}
				else if ( db === "incident summary")
				{
				voiceoutput("All the incidents created for this module have been closed. There are no pending incidents for the selected time period",2);
				}
				else if ( db === "incident trend")
				{
				voiceoutput("The root cause analysis says scheduling is the major reason for most of the incidents",2);
				}
				else if ( db === "service requests" || db === "service request")
				{
				voiceoutput("207 Service requests are open at beginning, 633 got newly created, 593 got closed and now working on 247 service requests",2);
				}
		}
		
		
		function valueCase(a) {
			var jsonvalue;
			$.ajax({
			async: false,
			dataType : 'json',
			url: "https://sharat543.github.io/POCvalues.json",
			type : 'GET',
			success: function(data) {
				for (var c = 0; c < data['values'].length; c++) {
				var jsonvaluelow = data['values'][c]['name'].toLowerCase();
				var valuelow = a.toLowerCase();
				if (jsonvaluelow === valuelow)
				{jsonvalue = data['values'][c]['name'];}
				}
			}});
			return jsonvalue;
		}
		
		function chooseSelectFilter(b) {
			var jsonfield; 
			$.ajax({
			async: false,
			dataType : 'json',
			url: "https://sharat543.github.io/POCfields.json",
			type : 'GET',
			success: function(data) {
				for (var d = 0; d < data['fields'].length; d++) {
				var jsonfieldlow = data['fields'][d]['name'].toLowerCase();
				var fieldlow = b.toLowerCase();
				if (jsonfieldlow === fieldlow)
				{jsonfield = data['fields'][d]['choosetype'];}
				}
			}});
			
			return jsonfield;
		}
        
        function OnComplete() {
            startBtn.disabled = false;
            stopBtn.disabled = true;
        }
       
          
    </script>
    <script type="text/javascript">
        $("#toggle-first-sidebar").click(function(){
            $(".first-sidebar-content").toggle();
        });
        $("#toggle-second-sidebar").click(function(){
            $(".second-sidebar-content").toggle();
        });
    </script>
            </body>

        <style>
            @font-face {
                font-family: Title;
                src: url("${pageContext.request.contextPath}/resources/scripts/Knockout-HTF27-JuniorBantamwt.otf");
            }

            @font-face {
                font-family: Description;
                src: url( "${pageContext.request.contextPath}/resources/scripts/FrutigerNextPro-Light.ttf");
            }

            body {
                background-image: url("${pageContext.request.contextPath}/resources/images/bgfinal.png");
            }

            .logo_deloitte {
                position: absolute;
                right: 2%;
                top: 5%;
                filter: grayscale(000%);
                color: #313131;
            }

            .logo_decibel {
                position: absolute;
                Left: 2%;
                top: 5%;
                filter: grayscale(000%);
                color: #313131;
            }

            .sabutton {
                position: absolute;
                Left: 27%;
                top: 5%;
                filter: grayscale(000%);
                height: 60px;
                width: 60px;
                color: #313131;
                cursor: pointer;
            }

            .stbutton {
                position: absolute;
                Left: 12%;
                top: 7%;
                filter: grayscale(000%);
                color: #313131;
            }

            .spbutton {
                position: absolute;
                Left: 17%;
                top: 7%;
                filter: grayscale(000%);
                color: #313131;
            }

            .head {
                position: relative;
                top: 1px;
                left: 1px;
                font-family: Title;
                font-size: 60px;
                color: #313131;
            }

            .head1 {
                position: absolute;
                top: 1.9%;
                left: 15%;
                font-family: Description;
                font-size: 20.5px;
                color: #313131;
            }

            .head2 {
                position: absolute;
                top: 4.85%;
                left: 15%;
                font-family: Description;
                font-size: 20.5px;
                color: #313131;
            }

            .head3 {
                position: absolute;
                top: 8%;
                left: 15%;
                font-family: Description;
                font-size: 20.5px;
                color: #313131;
            }

            .mic {
               display: block;
    			   margin:  auto;
    			   cursor: pointer;
            }
        </style>        
</html>