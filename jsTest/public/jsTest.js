'use strict'

var freqJson;

$(document).ready(function() {
  $("#inputText").focus();
	$.getJSON("./en_US.10.freq.10.fast.json", function(json) {
    freqJson = json;
	});	
});


$(document).on("keyup", ".reactiveTextarea", function(evt) {
	var el = $(evt.target)[0];
	var offset = el.offsetHeight - el.clientHeight;
	$(el).css('height', 'auto').css('height', el.scrollHeight + offset);
	updateInput(evt);
});

$(document).click(".reactiveTextarea", function(evt) { updateInput(evt); });

function updateInput (evt) {
	var el = $(evt.target)[0];
	$(el).trigger("change"); // triggers update
	var ngram = getNgram("inputText", 0),
			nWords = getWords(ngram);
	//Shiny.onInputChange("cursorPos", ngram);
}


function getNgram (textareaID, cursorInit) {
	
	textareaID = '#' + textareaID;
	var input = $(textareaID), // or $('#myinput')[0]
		cursorPos = input[0].selectionStart,
		inputText = input.val();
		
	// detect if selection
	if (input.selectionStart !== input.selectionEnd) {
		var selectionValue =
		input.value.substring(input.selectionStart, input.selectionEnd);
	}
	
	if (cursorInit>0) cursorPos = cursorInit;
	
	var beforePos = inputText.substring(0,cursorPos),
			afterPos = inputText.substring(cursorPos,inputText.length),
			lastChar = beforePos.slice(-1),
			pat = /^[a-zA-Z0-9\']+/;
	
	// check if cursor in a middle of a word; include full word if yes
	if (lastChar.match(pat) !== null && afterPos.match(pat) !== null) {
		var len = afterPos.match(pat)[0].length;
		cursorPos = cursorPos + len;
		beforePos = inputText.substring(0,cursorPos);
		afterPos = inputText.substring(cursorPos,inputText.length);
	}
	
	// take the last three words + current word
	var pat2 = /^(.*[^a-zA-Z0-9\' ])*([\n])*([a-zA-Z0-9\' ]*)/,
			currentWords = (".\n" + beforePos).match(pat2)[3].split(' ').slice(-4),
			previousWords = currentWords.slice(0,currentWords.length-1),
			currentWord = currentWords.slice(-1)[0];
			
	var ngram = {
		"previousWords": (previousWords.length==0 || previousWords.reduce((a,b) => a+b.length) == 0) ? ["eol#"] : previousWords,
		"currentWord": currentWord,
		"previousText": beforePos.substring(0,beforePos.length-currentWord.length),
		"nextText": afterPos,
		"cursorPos": cursorPos-currentWord.length
	}
	
	return(ngram)
}

function getWords (ngram) {
	
	var pW = ngram.previousWords,
			cW = ngram.currentWord,
			lenPW = pW.length,
			lenCW = cW.length;

	var token,tokenWords, iWords,sbScore, wordList = [];
	
	// loop on ngram freq tables (reverse) - JSON parse/stringify to deep copy the JSON
	for ( var i = lenPW; i>=0; i-- ) {
		
		// use previous words for ngrams > 1 
		if (lenPW>0 && i>0) {
			token = pW.slice(lenPW-i,lenPW).join(' ').toLowerCase();		
			tokenWords = freqJson[String(i+1)][token];
			if ( typeof(tokenWords) === 'undefined' ) continue; // skip if no match for the previous words
			iWords = JSON.parse(JSON.stringify(tokenWords));
		}
		// otherwise, i==0. We use the [az] freq table if a word is being typed
		else if ( lenCW>0 ) {
			if ( /[a-zA-Z]/.test(cW.substring(0,1)) ) {
				token = cW.substring(0,1).toLowerCase();
				tokenWords = freqJson["0"][token];
				if ( typeof(tokenWords) === 'undefined' ) continue; // skip if no match for the previous words
				iWords = JSON.parse(JSON.stringify(tokenWords));
			}
		}
		else {
			iWords = JSON.parse(JSON.stringify(freqJson["1"]));
		}
		
		// merge the two arrays into an array of arrays c2/score
		var iWordsArray=[], lenIW=iWords.c2.length;
		for (var j = 0; j < lenIW; j++) {
			iWordsArray.push([iWords.c2[j], iWords.score[j]])
		}
		
		// additional filtering for beg of word
		if (lenCW>0) {
			iWordsArray = iWordsArray.filter(function(el) {
				return (el[0].substring(0,lenCW) === cW);
			});
    }
		
		// keep only six elements ()
		iWordsArray = iWordsArray.slice(0,7);
		
		// remove last previous word from the suggested words
		if (lenPW>0) {
			var lastPW = pW.slice(-1)[0];
			iWordsArray = iWordsArray.filter(function(el) { return (el[0]!==lastPW); }); 
		}
		
		// update stupid backoff score 
		if (i < lenPW) {
			sbScore = Math.round((lenPW-i)*Math.log(0.4)*1000)/1000;
			iWordsArray = iWordsArray.map(function(el) { return [el[0],el[1] + sbScore]; });
		}
		
		// add current word
		if (lenCW>0) iWordsArray.push([cW,100]);
		
		// consolidate candidates
		iWordsArray.map(function(el) {
			if (typeof(wordList[el[0]])==='undefined' || wordList[el[0]] < el[1]) {
				wordList[el[0]]=el[1];
			}
		});
		
	}
	
	// sort candidates
	var sortable = [];
	for (var word in wordList) sortable.push([word, wordList[word]]);
	sortable.sort(function(a, b) {return b[1] - a[1]});
	var finalList = sortable.slice(0,3).map(function(el){return el[0];});
	
	console.log(finalList);
	return finalList;
	
}

function clean (iWords, word) {
	var idx = iWords.c2.indexOf(word);
	if ( idx !== -1 ) {
		iWords.c2.splice(idx,1); 
		iWords.score.splice(idx,1);
	}
	return (iWords);
}











