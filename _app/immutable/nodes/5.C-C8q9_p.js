import{B as e,I as t,M as n,N as r,O as i,R as a,S as o,V as s,X as c,Y as l,b as u,d,et as f,g as p,h as m,m as ee,nt as h,s as g,y as te,z as ne}from"../chunks/Ca4FMD-n.js";import{a as _}from"../chunks/Be-Q3yYC.js";import"../chunks/xihTtKlq.js";import{n as re,r as v,s as ie,t as ae}from"../chunks/42FSED3e.js";function y(){return{async:!1,breaks:!1,extensions:null,gfm:!0,hooks:null,pedantic:!1,renderer:null,silent:!1,tokenizer:null,walkTokens:null}}var b=y();function x(e){b=e}var S={exec:()=>null};function C(e){let t=[];return n=>{let r=Math.max(0,Math.min(3,n-1)),i=t[r];return i||(i=e(r),t[r]=i),i}}function w(e,t=``){let n=typeof e==`string`?e:e.source,r={replace:(e,t)=>{let i=typeof t==`string`?t:t.source;return i=i.replace(T.caret,`$1`),n=n.replace(e,i),r},getRegex:()=>new RegExp(n,t)};return r}var oe=((e=``)=>{try{return!!RegExp(`(?<=1)(?<!1)`+e)}catch{return!1}})(),T={codeRemoveIndent:/^(?: {1,4}| {0,3}\t)/gm,outputLinkReplace:/\\([\[\]])/g,indentCodeCompensation:/^(\s+)(?:```)/,beginningSpace:/^\s+/,endingHash:/#$/,startingSpaceChar:/^ /,endingSpaceChar:/ $/,nonSpaceChar:/[^ ]/,newLineCharGlobal:/\n/g,tabCharGlobal:/\t/g,multipleSpaceGlobal:/\s+/g,blankLine:/^[ \t]*$/,doubleBlankLine:/\n[ \t]*\n[ \t]*$/,blockquoteStart:/^ {0,3}>/,blockquoteSetextReplace:/\n {0,3}((?:=+|-+) *)(?=\n|$)/g,blockquoteSetextReplace2:/^ {0,3}>[ \t]?/gm,listReplaceNesting:/^ {1,4}(?=( {4})*[^ ])/g,listIsTask:/^\[[ xX]\] +\S/,listReplaceTask:/^\[[ xX]\] +/,listTaskCheckbox:/\[[ xX]\]/,anyLine:/\n.*\n/,hrefBrackets:/^<(.*)>$/,tableDelimiter:/[:|]/,tableAlignChars:/^\||\| *$/g,tableRowBlankLine:/\n[ \t]*$/,tableAlignRight:/^ *-+: *$/,tableAlignCenter:/^ *:-+: *$/,tableAlignLeft:/^ *:-+ *$/,startATag:/^<a /i,endATag:/^<\/a>/i,startPreScriptTag:/^<(pre|code|kbd|script)(\s|>)/i,endPreScriptTag:/^<\/(pre|code|kbd|script)(\s|>)/i,startAngleBracket:/^</,endAngleBracket:/>$/,pedanticHrefTitle:/^([^'"]*[^\s])\s+(['"])(.*)\2/,unicodeAlphaNumeric:/[\p{L}\p{N}]/u,escapeTest:/[&<>"']/,escapeReplace:/[&<>"']/g,escapeTestNoEncode:/[<>"']|&(?!(#\d{1,7}|#[Xx][a-fA-F0-9]{1,6}|\w+);)/,escapeReplaceNoEncode:/[<>"']|&(?!(#\d{1,7}|#[Xx][a-fA-F0-9]{1,6}|\w+);)/g,caret:/(^|[^\[])\^/g,percentDecode:/%25/g,findPipe:/\|/g,splitPipe:/ \|/,slashPipe:/\\\|/g,carriageReturn:/\r\n|\r/g,spaceLine:/^ +$/gm,notSpaceStart:/^\S*/,endingNewline:/\n$/,listItemRegex:e=>RegExp(`^( {0,3}${e})((?:[	 ][^\\n]*)?(?:\\n|$))`),nextBulletRegex:C(e=>RegExp(`^ {0,${e}}(?:[*+-]|\\d{1,9}[.)])((?:[ 	][^\\n]*)?(?:\\n|$))`)),hrRegex:C(e=>RegExp(`^ {0,${e}}((?:- *){3,}|(?:_ *){3,}|(?:\\* *){3,})(?:\\n+|$)`)),fencesBeginRegex:C(e=>RegExp(`^ {0,${e}}(?:\`\`\`|~~~)`)),headingBeginRegex:C(e=>RegExp(`^ {0,${e}}#`)),htmlBeginRegex:C(e=>RegExp(`^ {0,${e}}<(?:[a-z].*>|!--)`,`i`)),blockquoteBeginRegex:C(e=>RegExp(`^ {0,${e}}>`))},se=/^(?:[ \t]*(?:\n|$))+/,E=/^((?: {4}| {0,3}\t)[^\n]+(?:\n(?:[ \t]*(?:\n|$))*)?)+/,D=/^ {0,3}(`{3,}(?=[^`\n]*(?:\n|$))|~{3,})([^\n]*)(?:\n|$)(?:|([\s\S]*?)(?:\n|$))(?: {0,3}\1[~`]* *(?=\n|$)|$)/,O=/^ {0,3}((?:-[\t ]*){3,}|(?:_[ \t]*){3,}|(?:\*[ \t]*){3,})(?:\n+|$)/,k=/^ {0,3}(#{1,6})(?=\s|$)(.*)(?:\n+|$)/,A=/ {0,3}(?:[*+-]|\d{1,9}[.)])/,j=/^(?!bull |blockCode|fences|blockquote|heading|html|table)((?:.|\n(?!\s*?\n|bull |blockCode|fences|blockquote|heading|html|table))+?)\n {0,3}(=+|-+) *(?:\n+|$)/,M=w(j).replace(/bull/g,A).replace(/blockCode/g,/(?: {4}| {0,3}\t)/).replace(/fences/g,/ {0,3}(?:`{3,}|~{3,})/).replace(/blockquote/g,/ {0,3}>/).replace(/heading/g,/ {0,3}#{1,6}(?:\s|$)/).replace(/html/g,/ {0,3}<[^\n>]+>\n/).replace(/\|table/g,``).getRegex(),ce=w(j).replace(/bull/g,A).replace(/blockCode/g,/(?: {4}| {0,3}\t)/).replace(/fences/g,/ {0,3}(?:`{3,}|~{3,})/).replace(/blockquote/g,/ {0,3}>/).replace(/heading/g,/ {0,3}#{1,6}(?:\s|$)/).replace(/html/g,/ {0,3}<[^\n>]+>\n/).replace(/table/g,/ {0,3}\|?(?:[:\- ]*\|)+[\:\- ]*\n/).getRegex(),le=/^([^\n]+(?:\n(?!hr|heading|lheading|blockquote|fences|list|html|table|[ \t]+\n)[^\n]+)*)/,ue=/^[^\n]+/,de=/(?!\s*\])(?:\\[\s\S]|[^\[\]\\])+/,fe=w(/^ {0,3}\[(label)\]: *(?:\n[ \t]*)?([^<\s][^\s]*|<.*?>)(?:(?: +(?:\n[ \t]*)?| *\n[ \t]*)(title))? *(?:\n+|$)/).replace(`label`,de).replace(`title`,/(?:"(?:\\"?|[^"\\])*"|'[^'\n]*(?:\n[^'\n]+)*\n?'|\([^()]*\))/).getRegex(),pe=w(/^(bull)([ \t][^\n]*?)?(?:\n|$)/).replace(/bull/g,A).getRegex(),N=`address|article|aside|base|basefont|blockquote|body|caption|center|col|colgroup|dd|details|dialog|dir|div|dl|dt|fieldset|figcaption|figure|footer|form|frame|frameset|h[1-6]|head|header|hr|html|iframe|legend|li|link|main|menu|menuitem|meta|nav|noframes|ol|optgroup|option|p|param|search|section|summary|table|tbody|td|tfoot|th|thead|title|tr|track|ul`,P=/<!--(?:-?>|[\s\S]*?(?:-->|$))/,me=w(`^ {0,3}(?:<(script|pre|style|textarea)[\\s>][\\s\\S]*?(?:</\\1>[^\\n]*\\n*|$)|comment[^\\n]*(\\n+|$)|<\\?[\\s\\S]*?(?:\\?>[^\\n]*\\n*|$)|<![A-Z][\\s\\S]*?(?:>[^\\n]*\\n*|$)|<!\\[CDATA\\[[\\s\\S]*?(?:\\]\\]>[^\\n]*\\n*|$)|</?(tag)(?: +|\\n|/?>)[\\s\\S]*?(?:(?:\\n[ 	]*)+\\n|$)|<(?!script|pre|style|textarea)([a-z][\\w-]*)(?:attribute)*? */?>(?=[ \\t]*(?:\\n|$))[\\s\\S]*?(?:(?:\\n[ 	]*)+\\n|$)|</(?!script|pre|style|textarea)[a-z][\\w-]*\\s*>(?=[ \\t]*(?:\\n|$))[\\s\\S]*?(?:(?:\\n[ 	]*)+\\n|$))`,`i`).replace(`comment`,P).replace(`tag`,N).replace(`attribute`,/ +[a-zA-Z:_][\w.:-]*(?: *= *"[^"\n]*"| *= *'[^'\n]*'| *= *[^\s"'=<>`]+)?/).getRegex(),he=e=>w(le).replace(`hr`,O).replace(`heading`,` {0,3}#{1,6}(?:\\s|$)`).replace(`|lheading`,``).replace(`|table`,``).replace(`blockquote`,` {0,3}>`).replace(`fences`," {0,3}(?:`{3,}(?=[^`\\n]*(?:\\n|$))|~~~)[^\\n]*(?:\\n|$)").replace(`list`,e).replace(`html`,`</?(?:tag)(?: +|\\n|/?>)|<(?:script|pre|style|textarea|!--)`).replace(`tag`,N).getRegex(),ge=he(/ {0,3}(?:[*+-]|1[.)])[ \t]+[^ \t\n]/),_e=he(/ {0,3}(?:[*+-]|\d{1,9}[.)])(?:[ \t]|\n|$)/),F={blockquote:w(/^( {0,3}> ?(paragraph|[^\n]*)(?:\n|$))+/).replace(`paragraph`,_e).getRegex(),code:E,def:fe,fences:D,heading:k,hr:O,html:me,lheading:M,list:pe,newline:se,paragraph:ge,table:S,text:ue},ve=w(`^ *([^\\n ].*)\\n {0,3}((?:\\| *)?:?-+:? *(?:\\| *:?-+:? *)*(?:\\| *)?)(?:\\n((?:(?! *\\n|hr|heading|blockquote|code|fences|list|html).*(?:\\n|$))*)\\n*|$)`).replace(`hr`,O).replace(`heading`,` {0,3}#{1,6}(?:\\s|$)`).replace(`blockquote`,` {0,3}>`).replace(`code`,`(?: {4}| {0,3}	)[^\\n]`).replace(`fences`," {0,3}(?:`{3,}(?=[^`\\n]*(?:\\n|$))|~~~)[^\\n]*(?:\\n|$)").replace(`list`,` {0,3}(?:[*+-]|1[.)])[ \\t]`).replace(`html`,`</?(?:tag)(?: +|\\n|/?>)|<(?:script|pre|style|textarea|!--)`).replace(`tag`,N).getRegex(),ye={...F,lheading:ce,table:ve,paragraph:w(le).replace(`hr`,O).replace(`heading`,` {0,3}#{1,6}(?:\\s|$)`).replace(`|lheading`,``).replace(`table`,ve).replace(`blockquote`,` {0,3}>`).replace(`fences`," {0,3}(?:`{3,}(?=[^`\\n]*(?:\\n|$))|~~~)[^\\n]*(?:\\n|$)").replace(`list`,` {0,3}(?:[*+-]|1[.)])[ \\t]+[^ \\t\\n]`).replace(`html`,`</?(?:tag)(?: +|\\n|/?>)|<(?:script|pre|style|textarea|!--)`).replace(`tag`,N).getRegex()},be={...F,html:w(`^ *(?:comment *(?:\\n|\\s*$)|<(tag)[\\s\\S]+?</\\1> *(?:\\n{2,}|\\s*$)|<tag(?:"[^"]*"|'[^']*'|\\s[^'"/>\\s]*)*?/?> *(?:\\n{2,}|\\s*$))`).replace(`comment`,P).replace(/tag/g,`(?!(?:a|em|strong|small|s|cite|q|dfn|abbr|data|time|code|var|samp|kbd|sub|sup|i|b|u|mark|ruby|rt|rp|bdi|bdo|span|br|wbr|ins|del|img)\\b)\\w+(?!:|[^\\w\\s@]*@)\\b`).getRegex(),def:/^ *\[([^\]]+)\]: *<?([^\s>]+)>?(?: +(["(][^\n]+[")]))? *(?:\n+|$)/,heading:/^(#{1,6})(.*)(?:\n+|$)/,fences:S,lheading:/^(.+?)\n {0,3}(=+|-+) *(?:\n+|$)/,paragraph:w(le).replace(`hr`,O).replace(`heading`,` *#{1,6} *[^
]`).replace(`lheading`,M).replace(`|table`,``).replace(`blockquote`,` {0,3}>`).replace(`|fences`,``).replace(`|list`,``).replace(`|html`,``).replace(`|tag`,``).getRegex()},xe=/^\\([!"#$%&'()*+,\-./:;<=>?@\[\]\\^_`{|}~])/,Se=/^(`+)([^`]|[^`][\s\S]*?[^`])\1(?!`)/,Ce=/^( {2,}|\\)\n(?!\s*$)/,we=/^(`+|[^`])(?:(?= {2,}\n)|[\s\S]*?(?:(?=[\\<!\[`*_]|\b_|$)|[^ ](?= {2,}\n)))/,I=/[\p{P}\p{S}]/u,L=/[\s\p{P}\p{S}]/u,R=/[^\s\p{P}\p{S}]/u,Te=w(/^((?![*_])punctSpace)/,`u`).replace(/punctSpace/g,L).getRegex(),Ee=/[\p{Pi}\p{Ps}"']/u,De=/(?!~)[\p{P}\p{S}]/u,Oe=/(?!~)[\s\p{P}\p{S}]/u,ke=/(?:[^\s\p{P}\p{S}]|~)/u,Ae=w(/link|precode-code|html/,`g`).replace(`link`,/\[(?:[^\[\]`]|(?<a>`+)[^`]+\k<a>(?!`))*?\]\((?:\\[\s\S]|[^\\\(\)]|\((?:\\[\s\S]|[^\\\(\)])*\))*\)/).replace(`precode-`,oe?"(?<!`)()":"(^^|[^`])").replace(`code`,/(?<b>`+)[^`]+\k<b>(?!`)/).replace(`html`,/<(?! )[^<>]*?>/).getRegex(),je=/^(?:\*+(?:((?!\*)punct)|([^\s*]))?)|^_+(?:((?!_)punct)|([^\s_]))?/,Me=w(je,`u`).replace(/punct/g,I).getRegex(),Ne=w(je,`u`).replace(/punct/g,De).getRegex(),Pe=w(/^(?:\*+(?:((?!\*)(?!openQuote)punct)|([^\s*]))?)|^_+(?:((?!_)(?!openQuote)punct)|([^\s_]))?/,`u`).replace(/openQuote/g,Ee).replace(/punct/g,I).getRegex(),Fe=`^[^_*]*?__[^_*]*?\\*[^_*]*?(?=__)|[^*]+(?=[^*])|(?!\\*)punct(\\*+)(?=[\\s]|$)|notPunctSpace(\\*+)(?!\\*)(?=punctSpace|$)|(?!\\*)punctSpace(\\*+)(?=notPunctSpace)|[\\s](\\*+)(?!\\*)(?=punct)|(?!\\*)punct(\\*+)(?!\\*)(?=punct)|notPunctSpace(\\*+)(?=notPunctSpace)`,Ie=w(Fe,`gu`).replace(/notPunctSpace/g,R).replace(/punctSpace/g,L).replace(/punct/g,I).getRegex(),Le=w(Fe,`gu`).replace(/notPunctSpace/g,ke).replace(/punctSpace/g,Oe).replace(/punct/g,De).getRegex(),Re=w(`^[^_*]*?__[^_*]*?\\*[^_*]*?(?=__)|[^*]+(?=[^*])|(?!\\*)punct(\\*+)(?=[\\s]|$)|notPunctSpace(\\*+)(?!\\*)(?=punctSpace|$)|(?!\\*)[\\s](\\*+)(?=notPunctSpace)|[\\s](\\*+)(?!\\*)(?=punct)|(?!\\*)punct(\\*+)(?!\\*)(?=punct)|(?:(?!\\*)punct|notPunctSpace)(\\*+)(?!\\*)(?=notPunctSpace)`,`gu`).replace(/notPunctSpace/g,R).replace(/punctSpace/g,L).replace(/punct/g,I).getRegex(),ze=w(`^[^_*]*?\\*\\*[^_*]*?_[^_*]*?(?=\\*\\*)|[^_]+(?=[^_])|(?!_)punct(_+)(?=[\\s]|$)|notPunctSpace(_+)(?!_)(?=punctSpace|$)|(?!_)punctSpace(_+)(?=notPunctSpace)|[\\s](_+)(?!_)(?=punct)|(?!_)punct(_+)(?!_)(?=punct)`,`gu`).replace(/notPunctSpace/g,R).replace(/punctSpace/g,L).replace(/punct/g,I).getRegex(),Be=w(`^[^_*]*?\\*\\*[^_*]*?_[^_*]*?(?=\\*\\*)|[^_]+(?=[^_])|(?!_)punct(_+)(?=[\\s]|$)|notPunctSpace(_+)(?!_)(?=punctSpace|$)|(?!_)[\\s](_+)(?=notPunctSpace)|[\\s](_+)(?!_)(?=punct)|(?!_)punct(_+)(?!_)(?=punct)|(?:(?!_)punct|notPunctSpace)(_+)(?!_)(?=notPunctSpace)`,`gu`).replace(/notPunctSpace/g,R).replace(/punctSpace/g,L).replace(/punct/g,I).getRegex(),Ve=w(/^~~?(?:((?!~)punct)|[^\s~])/,`u`).replace(/punct/g,I).getRegex(),He=w(`^[^~]+(?=[^~])|(?!~)punct(~~?)(?=[\\s]|$)|notPunctSpace(~~?)(?!~)(?=punctSpace|$)|(?!~)punctSpace(~~?)(?=notPunctSpace)|[\\s](~~?)(?!~)(?=punct)|(?!~)punct(~~?)(?!~)(?=punct)|notPunctSpace(~~?)(?=notPunctSpace)`,`gu`).replace(/notPunctSpace/g,R).replace(/punctSpace/g,L).replace(/punct/g,I).getRegex(),Ue=w(/\\(punct)/,`gu`).replace(/punct/g,I).getRegex(),We=w(/^<(scheme:[^\s\x00-\x1f<>]*|email)>/).replace(`scheme`,/[a-zA-Z][a-zA-Z0-9+.-]{1,31}/).replace(`email`,/[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+(@)[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+(?![-_])/).getRegex(),Ge=w(P).replace(`(?:-->|$)`,`-->`).getRegex(),Ke=w(`^comment|^</[a-zA-Z][\\w:-]*\\s*>|^<[a-zA-Z][\\w-]*(?:attribute)*?\\s*/?>|^<\\?[\\s\\S]*?\\?>|^<![a-zA-Z]+\\s[\\s\\S]*?>|^<!\\[CDATA\\[[\\s\\S]*?\\]\\]>`).replace(`comment`,Ge).replace(`attribute`,/\s+[a-zA-Z:_][\w.:-]*(?:\s*=\s*"[^"]*"|\s*=\s*'[^']*'|\s*=\s*[^\s"'=<>`]+)?/).getRegex(),z=/(?:\[(?:\\[\s\S]|[^\[\]\\])*\]|\\[\s\S]|`+(?!`)[^`]*?`+(?!`)|``+(?=\])|[^\[\]\\`])*?/,qe=w(/^!?\[(label)\]\(\s*(href)(?:(?:[ \t]+(?:\n[ \t]*)?|\n[ \t]*)(title))?\s*\)/).replace(`label`,z).replace(`href`,/<(?:\\.|[^\n<>\\])+>|[^ \t\n\x00-\x1f]+|(?=\))/).replace(`title`,/"(?:\\"?|[^"\\])*"|'(?:\\'?|[^'\\])*'|\((?:\\\)?|[^)\\])*\)/).getRegex(),Je=w(/^!?\[(label)\]\[(ref)\]/).replace(`label`,z).replace(`ref`,de).getRegex(),Ye=w(/^!?\[(ref)\](?:\[\])?/).replace(`ref`,de).getRegex(),Xe=w(`reflink|nolink(?!\\()`,`g`).replace(`reflink`,Je).replace(`nolink`,Ye).getRegex(),Ze=/[hH][tT][tT][pP][sS]?|[fF][tT][pP]/,B={_backpedal:S,anyPunctuation:Ue,autolink:We,blockSkip:Ae,br:Ce,code:Se,del:S,delLDelim:S,delRDelim:S,emStrongLDelim:Me,emStrongRDelimAst:Ie,emStrongRDelimUnd:ze,escape:xe,link:qe,nolink:Ye,punctuation:Te,reflink:Je,reflinkSearch:Xe,tag:Ke,text:we,url:S},Qe={...B,emStrongLDelim:Pe,emStrongRDelimAst:Re,emStrongRDelimUnd:Be,link:w(/^!?\[(label)\]\((.*?)\)/).replace(`label`,z).getRegex(),reflink:w(/^!?\[(label)\]\s*\[([^\]]*)\]/).replace(`label`,z).getRegex()},V={...B,emStrongRDelimAst:Le,emStrongLDelim:Ne,delLDelim:Ve,delRDelim:He,url:w(/^((?:protocol):\/\/|www\.)(?:[a-zA-Z0-9\-]+\.?)+[^\s<]*|^email/).replace(`protocol`,Ze).replace(`email`,/[A-Za-z0-9._+-]+(@)[a-zA-Z0-9-_]+(?:\.[a-zA-Z0-9-_]*[a-zA-Z0-9])+(?![-_])/).getRegex(),_backpedal:/(?:[^?!.,:;*_'"~()&]+|\([^)]*\)|&(?![a-zA-Z0-9]+;$)|[?!.,:;*_'"~)]+(?!$))+/,del:/^(~~?)(?=[^\s~])((?:\\[\s\S]|[^\\])*?(?:\\[\s\S]|[^\s~\\]))\1(?=[^~]|$)/,text:w(/^(`+|~+|[^`~])(?:(?=[`~])|(?= {2,}\n)|(?=[a-zA-Z0-9.!#$%&'*+\/=?_`{\|}~-]+@)|[\s\S]*?(?:(?=[\\<!\[`*~_]|\b_|protocol:\/\/|www\.|$)|[^ ](?= {2,}\n)|[^a-zA-Z0-9.!#$%&'*+\/=?_`{\|}~-](?=[a-zA-Z0-9.!#$%&'*+\/=?_`{\|}~-]+@)))/).replace(`protocol`,Ze).getRegex()},$e={...V,br:w(Ce).replace(`{2,}`,`*`).getRegex(),text:w(V.text).replace(`\\b_`,`\\b_| {2,}\\n`).replace(/\{2,\}/g,`*`).getRegex()},H={normal:F,gfm:ye,pedantic:be},U={normal:B,gfm:V,breaks:$e,pedantic:Qe},et={"&":`&amp;`,"<":`&lt;`,">":`&gt;`,'"':`&quot;`,"'":`&#39;`},tt=e=>et[e];function W(e,t){if(t){if(T.escapeTest.test(e))return e.replace(T.escapeReplace,tt)}else if(T.escapeTestNoEncode.test(e))return e.replace(T.escapeReplaceNoEncode,tt);return e}function nt(e){try{e=encodeURI(e).replace(T.percentDecode,`%`)}catch{return null}return e}function rt(e,t){let n=e.replace(T.findPipe,(e,t,n)=>{let r=!1,i=t;for(;--i>=0&&n[i]===`\\`;)r=!r;return r?`|`:` |`}).split(T.splitPipe),r=0;if(n[0].trim()||n.shift(),n.length>0&&!n.at(-1)?.trim()&&n.pop(),t){if(n.length>t)n.splice(t);else for(;n.length<t;)n.push(``)}for(;r<n.length;r++)n[r]=n[r].trim().replace(T.slashPipe,`|`);return n}function G(e,t,n){let r=e.length;if(r===0)return``;let i=0;for(;i<r;){let a=e.charAt(r-i-1);if(a===t&&!n)i++;else if(a!==t&&n)i++;else break}return e.slice(0,r-i)}function it(e){let t=e.split(`
`),n=t.length-1;for(;n>=0&&T.blankLine.test(t[n]);)n--;return t.length-n<=2?e:t.slice(0,n+1).join(`
`)}function at(e,t){if(e.indexOf(t[1])===-1)return-1;let n=0;for(let r=0;r<e.length;r++)if(e[r]===`\\`)r++;else if(e[r]===t[0])n++;else if(e[r]===t[1]&&(n--,n<0))return r;return n>0?-2:-1}function ot(e,t=0){let n=t,r=``;for(let t of e)if(t===`	`){let e=4-n%4;r+=` `.repeat(e),n+=e}else r+=t,n++;return r}function st(e,t,n,r,i){let a=t.href,o=t.title||null,s=e[1].replace(i.other.outputLinkReplace,`$1`),c=e[0].charAt(0)===`!`;r.state.inLink=!0;let l=r.state.linkEmitted,u=r.state.inRawBlock;r.state.linkEmitted=!1;let d=r.inlineTokens(s),f=r.state.linkEmitted;if(r.state.linkEmitted=l,r.state.inLink=!1,!c){if(f){r.state.inRawBlock=u;return}r.state.linkEmitted=!0}return{type:c?`image`:`link`,raw:n,href:a,title:o,text:s,tokens:d}}function ct(e,t,n){let r=e.match(n.other.indentCodeCompensation);if(r===null)return t;let i=r[1];return t.split(`
`).map(e=>{let t=e.match(n.other.beginningSpace);if(t===null)return e;let[r]=t;return r.length>=i.length?e.slice(i.length):e}).join(`
`)}var K=class{options;rules;lexer;constructor(e){this.options=e||b}space(e){let t=this.rules.block.newline.exec(e);if(t&&t[0].length>0)return{type:`space`,raw:t[0]}}code(e){let t=this.rules.block.code.exec(e);if(t){let e=this.options.pedantic?t[0]:it(t[0]);return{type:`code`,raw:e,codeBlockStyle:`indented`,text:e.replace(this.rules.other.codeRemoveIndent,``)}}}fences(e){let t=this.rules.block.fences.exec(e);if(t){let e=t[0],n=ct(e,t[3]||``,this.rules);return{type:`code`,raw:e,lang:t[2]?t[2].trim().replace(this.rules.inline.anyPunctuation,`$1`):t[2],text:n}}}heading(e){let t=this.rules.block.heading.exec(e);if(t){let e=t[2].trim();if(this.rules.other.endingHash.test(e)){let t=G(e,`#`);(this.options.pedantic||!t||this.rules.other.endingSpaceChar.test(t))&&(e=t.trim())}return{type:`heading`,raw:G(t[0],`
`),depth:t[1].length,text:e,tokens:this.lexer.inline(e)}}}hr(e){let t=this.rules.block.hr.exec(e);if(t)return{type:`hr`,raw:G(t[0],`
`)}}blockquote(e){let t=this.rules.block.blockquote.exec(e);if(t){let e=G(t[0],`
`).split(`
`),n=``,r=``,i=[];for(;e.length>0;){let t=!1,a=[],o=0;for(;o<e.length;o++)if(this.rules.other.blockquoteStart.test(e[o]))a.push(e[o]),t=!0;else if(!t)a.push(e[o]);else break;e=e.slice(o);let s=a.join(`
`),c=s.replace(this.rules.other.blockquoteSetextReplace,`
    $1`).replace(this.rules.other.blockquoteSetextReplace2,``);n=n?`${n}
${s}`:s,r=r?`${r}
${c}`:c;let l=this.lexer.state.top;if(this.lexer.state.top=!0,this.lexer.blockTokens(c,i,!0),this.lexer.state.top=l,e.length===0)break;let u=i.at(-1);if(u?.type===`code`)break;if(u?.type===`blockquote`){let t=u,a=e.join(`
`),o=t.raw+`
`+a.replace(this.rules.other.blockquoteSetextReplace2,``),s=this.blockquote(o);i[i.length-1]=s,n=`${n}
${a}`,r=r.substring(0,r.length-t.text.length)+s.text;break}if(u?.type===`list`){let t=u,a=t.raw+`
`+e.join(`
`),o=this.list(a);i[i.length-1]=o,n=n.substring(0,n.length-u.raw.length)+o.raw,r=r.substring(0,r.length-t.raw.length)+o.raw,e=a.substring(i.at(-1).raw.length).split(`
`);continue}}return{type:`blockquote`,raw:n,tokens:i,text:r}}}list(e){let t=this.rules.block.list.exec(e);if(t){let n=t[1].trim(),r=n.length>1,i={type:`list`,raw:``,ordered:r,start:r?+n.slice(0,-1):``,loose:!1,items:[]};n=r?`\\d{1,9}\\${n.slice(-1)}`:`\\${n}`,this.options.pedantic&&(n=r?n:`[*+-]`);let a=this.rules.other.listItemRegex(n),o=!1;for(;e;){let n=!1,r=``,s=``;if(!(t=a.exec(e))||this.rules.block.hr.test(e))break;r=t[0],e=e.substring(r.length);let c=ot(t[2].split(`
`,1)[0],t[1].length),l=e.split(`
`,1)[0],u=!c.trim(),d=0;if(this.options.pedantic?(d=2,s=c.trimStart()):u?d=t[1].length+1:(d=c.search(this.rules.other.nonSpaceChar),d=d>4?1:d,s=c.slice(d),d+=t[1].length),u&&this.rules.other.blankLine.test(l)&&(r+=l+`
`,e=e.substring(l.length+1),n=!0),!n){let t=this.rules.other.nextBulletRegex(d),n=this.rules.other.hrRegex(d),i=this.rules.other.fencesBeginRegex(d),a=this.rules.other.headingBeginRegex(d),o=this.rules.other.htmlBeginRegex(d),f=this.rules.other.blockquoteBeginRegex(d);for(;e;){let p=e.split(`
`,1)[0],m;if(l=p,this.options.pedantic?(l=l.replace(this.rules.other.listReplaceNesting,`  `),m=l):m=l.replace(this.rules.other.tabCharGlobal,`    `),i.test(l)||a.test(l)||o.test(l)||f.test(l)||t.test(l)||n.test(l))break;if(m.search(this.rules.other.nonSpaceChar)>=d||!l.trim())s+=`
`+m.slice(d);else{if(u||c.replace(this.rules.other.tabCharGlobal,`    `).search(this.rules.other.nonSpaceChar)>=4||i.test(c)||a.test(c)||n.test(c))break;s+=`
`+l}u=!l.trim(),r+=p+`
`,e=e.substring(p.length+1),c=m.slice(d)}}i.loose||(o?i.loose=!0:this.rules.other.doubleBlankLine.test(r)&&(o=!0)),i.items.push({type:`list_item`,raw:r,task:!!this.options.gfm&&this.rules.other.listIsTask.test(s),loose:!1,text:s,tokens:[]}),i.raw+=r}let s=i.items.at(-1);if(s)s.raw=s.raw.trimEnd(),s.text=s.text.trimEnd();else return;i.raw=i.raw.trimEnd();for(let e of i.items)if(this.lexer.state.top=!1,e.tokens=this.lexer.blockTokens(e.text,[]),!i.loose){let t=e.tokens.filter(e=>e.type===`space`);i.loose=t.length>0&&t.some(e=>this.rules.other.anyLine.test(e.raw))}for(let e of i.items){let t=e.tokens[0];if(e.task&&(t?.type===`text`||t?.type===`paragraph`)){e.text=e.text.replace(this.rules.other.listReplaceTask,``),t.raw=t.raw.replace(this.rules.other.listReplaceTask,``),t.text=t.text.replace(this.rules.other.listReplaceTask,``);for(let e=this.lexer.inlineQueue.length-1;e>=0;e--)if(this.rules.other.listIsTask.test(this.lexer.inlineQueue[e].src)){this.lexer.inlineQueue[e].src=this.lexer.inlineQueue[e].src.replace(this.rules.other.listReplaceTask,``);break}let n=this.rules.other.listTaskCheckbox.exec(e.raw);if(n){let t={type:`checkbox`,raw:n[0]+` `,checked:n[0]!==`[ ]`};e.checked=t.checked,i.loose?e.tokens[0]&&[`paragraph`,`text`].includes(e.tokens[0].type)&&`tokens`in e.tokens[0]&&e.tokens[0].tokens?(e.tokens[0].raw=t.raw+e.tokens[0].raw,e.tokens[0].text=t.raw+e.tokens[0].text,e.tokens[0].tokens.unshift(t)):e.tokens.unshift({type:`paragraph`,raw:t.raw,text:t.raw,tokens:[t]}):e.tokens.unshift(t)}}else e.task&&=!1}if(i.loose)for(let e of i.items){e.loose=!0;for(let t of e.tokens)t.type===`text`&&(t.type=`paragraph`)}return i}}html(e){let t=this.rules.block.html.exec(e);if(t){let e=it(t[0]);return{type:`html`,block:!0,raw:e,pre:t[1]===`pre`||t[1]===`script`||t[1]===`style`,text:e}}}def(e){let t=this.rules.block.def.exec(e);if(t){let e=t[1].toLowerCase().replace(this.rules.other.multipleSpaceGlobal,` `),n=t[2]?t[2].replace(this.rules.other.hrefBrackets,`$1`).replace(this.rules.inline.anyPunctuation,`$1`):``,r=t[3]?t[3].substring(1,t[3].length-1).replace(this.rules.inline.anyPunctuation,`$1`):t[3];return{type:`def`,tag:e,raw:G(t[0],`
`),href:n,title:r}}}table(e){let t=this.rules.block.table.exec(e);if(!t||!this.rules.other.tableDelimiter.test(t[2]))return;let n=rt(t[1]),r=t[2].replace(this.rules.other.tableAlignChars,``).split(`|`),i=t[3]?.trim()?t[3].replace(this.rules.other.tableRowBlankLine,``).split(`
`):[],a={type:`table`,raw:G(t[0],`
`),header:[],align:[],rows:[]};if(n.length===r.length){for(let e of r)this.rules.other.tableAlignRight.test(e)?a.align.push(`right`):this.rules.other.tableAlignCenter.test(e)?a.align.push(`center`):this.rules.other.tableAlignLeft.test(e)?a.align.push(`left`):a.align.push(null);for(let e=0;e<n.length;e++)a.header.push({text:n[e],tokens:this.lexer.inline(n[e]),header:!0,align:a.align[e]});for(let e of i)a.rows.push(rt(e,a.header.length).map((e,t)=>({text:e,tokens:this.lexer.inline(e),header:!1,align:a.align[t]})));return a}}lheading(e){let t=this.rules.block.lheading.exec(e);if(t){let e=t[1].trim();return{type:`heading`,raw:G(t[0],`
`),depth:t[2].charAt(0)===`=`?1:2,text:e,tokens:this.lexer.inline(e)}}}paragraph(e){let t=this.rules.block.paragraph.exec(e);if(t){let e=t[1].charAt(t[1].length-1)===`
`?t[1].slice(0,-1):t[1];return{type:`paragraph`,raw:t[0],text:e,tokens:this.lexer.inline(e)}}}text(e){let t=this.rules.block.text.exec(e);if(t)return{type:`text`,raw:t[0],text:t[0],tokens:this.lexer.inline(t[0])}}escape(e){let t=this.rules.inline.escape.exec(e);if(t)return{type:`escape`,raw:t[0],text:t[1]}}tag(e){let t=this.rules.inline.tag.exec(e);if(t)return!this.lexer.state.inLink&&this.rules.other.startATag.test(t[0])?this.lexer.state.inLink=!0:this.lexer.state.inLink&&this.rules.other.endATag.test(t[0])&&(this.lexer.state.inLink=!1),!this.lexer.state.inRawBlock&&this.rules.other.startPreScriptTag.test(t[0])?this.lexer.state.inRawBlock=!0:this.lexer.state.inRawBlock&&this.rules.other.endPreScriptTag.test(t[0])&&(this.lexer.state.inRawBlock=!1),{type:`html`,raw:t[0],inLink:this.lexer.state.inLink,inRawBlock:this.lexer.state.inRawBlock,block:!1,text:t[0]}}link(e){let t=this.rules.inline.link.exec(e);if(t){let e=t[2].trim();if(!this.options.pedantic&&this.rules.other.startAngleBracket.test(e)){if(!this.rules.other.endAngleBracket.test(e))return;let t=G(e.slice(0,-1),`\\`);if((e.length-t.length)%2==0)return}else{let e=at(t[2],`()`);if(e===-2)return;if(e>-1){let n=(t[0].indexOf(`!`)===0?5:4)+t[1].length+e;t[2]=t[2].substring(0,e),t[0]=t[0].substring(0,n).trim(),t[3]=``}}let n=t[2],r=``;if(this.options.pedantic){let e=this.rules.other.pedanticHrefTitle.exec(n);e&&(n=e[1],r=e[3])}else r=t[3]?t[3].slice(1,-1):``;return n=n.trim(),this.rules.other.startAngleBracket.test(n)&&(n=this.options.pedantic&&!this.rules.other.endAngleBracket.test(e)?n.slice(1):n.slice(1,-1)),st(t,{href:n&&n.replace(this.rules.inline.anyPunctuation,`$1`),title:r&&r.replace(this.rules.inline.anyPunctuation,`$1`)},t[0],this.lexer,this.rules)}}reflink(e,t){let n;if((n=this.rules.inline.reflink.exec(e))||(n=this.rules.inline.nolink.exec(e))){let e=t[(n[2]||n[1]).replace(this.rules.other.multipleSpaceGlobal,` `).toLowerCase()];if(!e){let e=n[0].charAt(0);return{type:`text`,raw:e,text:e}}return st(n,e,n[0],this.lexer,this.rules)}}emStrong(e,t,n=``){let r=this.rules.inline.emStrongLDelim.exec(e);if(!(!r||!r[1]&&!r[2]&&!r[3]&&!r[4]||r[4]&&n.match(this.rules.other.unicodeAlphaNumeric))&&(!(r[1]||r[3])||!n||this.rules.inline.punctuation.exec(n))){let i=[...r[0]].length-1,a,o,s=i,c=0,l=r[0][0],u=n===l,d=l===`*`?this.rules.inline.emStrongRDelimAst:this.rules.inline.emStrongRDelimUnd;for(d.lastIndex=0,t=t.slice(-1*e.length+i);(r=d.exec(t))!==null;){if(a=r[1]||r[2]||r[3]||r[4]||r[5]||r[6],!a)continue;if(o=[...a].length,r[3]||r[4]){s+=o;continue}if(r[5]||r[6]){if(i%3&&!((i+o)%3)){c+=o;continue}if(u)break}if(s-=o,s>0)continue;o=Math.min(o,o+s+c);let t=[...r[0]][0].length,n=e.slice(0,i+r.index+t+o);if(Math.min(i,o)%2){let e=n.slice(1,-1);return{type:`em`,raw:n,text:e,tokens:this.lexer.inlineTokens(e)}}let l=n.slice(2,-2);return{type:`strong`,raw:n,text:l,tokens:this.lexer.inlineTokens(l)}}}}codespan(e){let t=this.rules.inline.code.exec(e);if(t){let e=t[2].replace(this.rules.other.newLineCharGlobal,` `),n=this.rules.other.nonSpaceChar.test(e),r=this.rules.other.startingSpaceChar.test(e)&&this.rules.other.endingSpaceChar.test(e);return n&&r&&(e=e.substring(1,e.length-1)),{type:`codespan`,raw:t[0],text:e}}}br(e){let t=this.rules.inline.br.exec(e);if(t)return{type:`br`,raw:t[0]}}del(e,t,n=``){let r=this.rules.inline.delLDelim.exec(e);if(r&&(!r[1]||!n||this.rules.inline.punctuation.exec(n))){let n=[...r[0]].length-1,i,a,o=n,s=this.rules.inline.delRDelim;for(s.lastIndex=0,t=t.slice(-1*e.length+n);(r=s.exec(t))!==null;){if(i=r[1]||r[2]||r[3]||r[4]||r[5]||r[6],!i||(a=[...i].length,a!==n))continue;if(r[3]||r[4]){o+=a;continue}if(o-=a,o>0)continue;a=Math.min(a,a+o);let t=[...r[0]][0].length,s=e.slice(0,n+r.index+t+a),c=s.slice(n,-n);return{type:`del`,raw:s,text:c,tokens:this.lexer.inlineTokens(c)}}}}autolink(e){let t=this.rules.inline.autolink.exec(e);if(t){let e,n;return t[2]===`@`?(e=t[1],n=`mailto:`+e):(e=t[1],n=e),{type:`link`,raw:t[0],text:e,href:n,tokens:[{type:`text`,raw:e,text:e}]}}}url(e){let t;if(t=this.rules.inline.url.exec(e)){let e,n;if(t[2]===`@`)e=t[0],n=`mailto:`+e;else{let r;do r=t[0],t[0]=this.rules.inline._backpedal.exec(t[0])?.[0]??``;while(r!==t[0]);e=t[0],n=t[1]===`www.`?`http://`+t[0]:t[0]}return{type:`link`,raw:t[0],text:e,href:n,tokens:[{type:`text`,raw:e,text:e}]}}}inlineText(e){let t=this.rules.inline.text.exec(e);if(t){let e=this.lexer.state.inRawBlock;return{type:`text`,raw:t[0],text:t[0],escaped:e}}}},q=class e{tokens;options;state;inlineQueue;tokenizer;constructor(e){this.tokens=[],this.tokens.links=Object.create(null),this.options=e||b,this.options.tokenizer=this.options.tokenizer||new K,this.tokenizer=this.options.tokenizer,this.tokenizer.options=this.options,this.tokenizer.lexer=this,this.inlineQueue=[],this.state={inLink:!1,inRawBlock:!1,linkEmitted:!1,top:!0};let t={other:T,block:H.normal,inline:U.normal};this.options.pedantic?(t.block=H.pedantic,t.inline=U.pedantic):this.options.gfm&&(t.block=H.gfm,t.inline=this.options.breaks?U.breaks:U.gfm),this.tokenizer.rules=t}static get rules(){return{block:H,inline:U}}static lex(t,n){return new e(n).lex(t)}static lexInline(t,n){return new e(n).inlineTokens(t)}lex(e){e=e.replace(T.carriageReturn,`
`),this.blockTokens(e,this.tokens);for(let e=0;e<this.inlineQueue.length;e++){let t=this.inlineQueue[e];this.inlineTokens(t.src,t.tokens)}return this.inlineQueue=[],this.tokens}blockTokens(e,t=[],n=!1){this.tokenizer.lexer=this,this.options.pedantic&&(e=e.replace(T.tabCharGlobal,`    `).replace(T.spaceLine,``));let r=1/0;for(;e;){if(e.length<r)r=e.length;else{this.infiniteLoopError(e.charCodeAt(0));break}let i;if(this.options.extensions?.block?.some(n=>(i=n.call({lexer:this},e,t))?(e=e.substring(i.raw.length),t.push(i),!0):!1))continue;if(i=this.tokenizer.space(e)){e=e.substring(i.raw.length);let n=t.at(-1);i.raw.length===1&&n!==void 0?n.raw+=`
`:t.push(i);continue}if(i=this.tokenizer.code(e)){e=e.substring(i.raw.length);let n=t.at(-1);n?.type===`paragraph`||n?.type===`text`?(n.raw+=(n.raw.endsWith(`
`)?``:`
`)+i.raw,n.text+=`
`+i.text,this.inlineQueue.at(-1).src=n.text):t.push(i);continue}if(i=this.tokenizer.fences(e)){e=e.substring(i.raw.length),t.push(i);continue}if(i=this.tokenizer.heading(e)){e=e.substring(i.raw.length),t.push(i);continue}if(i=this.tokenizer.hr(e)){e=e.substring(i.raw.length),t.push(i);continue}if(i=this.tokenizer.blockquote(e)){e=e.substring(i.raw.length),t.push(i);continue}if(i=this.tokenizer.list(e)){e=e.substring(i.raw.length),t.push(i);continue}if(i=this.tokenizer.html(e)){e=e.substring(i.raw.length),t.push(i);continue}if(i=this.tokenizer.def(e)){e=e.substring(i.raw.length);let n=t.at(-1);n?.type===`paragraph`||n?.type===`text`?(n.raw+=(n.raw.endsWith(`
`)?``:`
`)+i.raw,n.text+=`
`+i.raw,this.inlineQueue.at(-1).src=n.text):this.tokens.links[i.tag]||(this.tokens.links[i.tag]={href:i.href,title:i.title},t.push(i));continue}if(i=this.tokenizer.table(e)){e=e.substring(i.raw.length),t.push(i);continue}if(i=this.tokenizer.lheading(e)){e=e.substring(i.raw.length),t.push(i);continue}let a=e;if(this.options.extensions?.startBlock){let t=1/0,n=e.slice(1),r;this.options.extensions.startBlock.forEach(e=>{r=e.call({lexer:this},n),typeof r==`number`&&r>=0&&(t=Math.min(t,r))}),t<1/0&&t>=0&&(a=e.substring(0,t+1))}if(this.state.top&&(i=this.tokenizer.paragraph(a))){let r=t.at(-1);n&&r?.type===`paragraph`?(r.raw+=(r.raw.endsWith(`
`)?``:`
`)+i.raw,r.text+=`
`+i.text,this.inlineQueue.pop(),this.inlineQueue.at(-1).src=r.text):t.push(i),n=a.length!==e.length,e=e.substring(i.raw.length);continue}if(i=this.tokenizer.text(e)){e=e.substring(i.raw.length);let n=t.at(-1);n?.type===`text`?(n.raw+=(n.raw.endsWith(`
`)?``:`
`)+i.raw,n.text+=`
`+i.text,this.inlineQueue.pop(),this.inlineQueue.at(-1).src=n.text):t.push(i);continue}if(e){this.infiniteLoopError(e.charCodeAt(0));break}}return this.state.top=!0,t}inline(e,t=[]){return this.inlineQueue.push({src:e,tokens:t}),t}linkInText(e){if(!e.includes(`[`))return!1;let t=this.tokenizer.rules.inline.link;for(let n of e.matchAll(this.tokenizer.rules.inline.blockSkip))if(t.test(n[0])&&e.charAt(n.index-1)!==`!`)return!0;for(let t of e.matchAll(this.tokenizer.rules.inline.reflinkSearch)){let e=t[0],n=e.lastIndexOf(`[`);if(e.charAt(0)!==`!`&&Object.hasOwn(this.tokens.links,e.slice(n+1,-1))&&!(n>1&&this.linkInText(e.slice(1,n-1))))return!0}return!1}inlineTokens(e,t=[]){this.tokenizer.lexer=this;let n=e;if(this.tokens.links&&e.includes(`[`)){let e=this.tokenizer.rules.inline.reflinkSearch,t=n=>{let r=n.lastIndexOf(`[`);if(!Object.hasOwn(this.tokens.links,n.slice(r+1,-1)))return n;if(r>1&&n.charAt(0)!==`!`){let i=n.slice(1,r-1);if(this.linkInText(i))return`[`+i.replace(e,t)+`][`+`a`.repeat(n.length-r-2)+`]`}return`[`+`a`.repeat(n.length-2)+`]`};n=n.replace(e,t)}n=n.replace(this.tokenizer.rules.inline.anyPunctuation,e=>`+`.repeat(e.length)),n=n.replace(this.tokenizer.rules.inline.blockSkip,(e,t,n)=>{let r=n?n.length:0;return e.slice(0,r)+`[`+`a`.repeat(e.length-r-2)+`]`}),n=this.options.hooks?.emStrongMask?.call({lexer:this},n)??n;let r=!1,i=``,a=1/0;for(;e;){if(e.length<a)a=e.length;else{this.infiniteLoopError(e.charCodeAt(0));break}r||(i=``),r=!1;let o;if(this.options.extensions?.inline?.some(n=>(o=n.call({lexer:this},e,t))?(e=e.substring(o.raw.length),t.push(o),!0):!1))continue;if(o=this.tokenizer.escape(e)){e=e.substring(o.raw.length),t.push(o);continue}if(o=this.tokenizer.tag(e)){e=e.substring(o.raw.length),t.push(o);continue}if(o=this.tokenizer.link(e)){e=e.substring(o.raw.length),t.push(o);continue}if(o=this.tokenizer.reflink(e,this.tokens.links)){e=e.substring(o.raw.length);let n=t.at(-1);o.type===`text`&&n?.type===`text`?(n.raw+=o.raw,n.text+=o.text):t.push(o);continue}if(o=this.tokenizer.emStrong(e,n,i)){e=e.substring(o.raw.length),t.push(o);continue}if(o=this.tokenizer.codespan(e)){e=e.substring(o.raw.length),t.push(o);continue}if(o=this.tokenizer.br(e)){e=e.substring(o.raw.length),t.push(o);continue}if(o=this.tokenizer.del(e,n,i)){e=e.substring(o.raw.length),t.push(o);continue}if(o=this.tokenizer.autolink(e)){e=e.substring(o.raw.length),t.push(o);continue}if(!this.state.inLink&&(o=this.tokenizer.url(e))){e=e.substring(o.raw.length),t.push(o);continue}let s=e;if(this.options.extensions?.startInline){let t=1/0,n=e.slice(1),r;this.options.extensions.startInline.forEach(e=>{r=e.call({lexer:this},n),typeof r==`number`&&r>=0&&(t=Math.min(t,r))}),t<1/0&&t>=0&&(s=e.substring(0,t+1))}if(o=this.tokenizer.inlineText(s)){e=e.substring(o.raw.length),o.raw.slice(-1)!==`_`&&(i=o.raw.slice(-1)),r=!0;let n=t.at(-1);n?.type===`text`?(n.raw+=o.raw,n.text+=o.text):t.push(o);continue}if(e){this.infiniteLoopError(e.charCodeAt(0));break}}return t}infiniteLoopError(e){let t=`Infinite loop on byte: `+e;if(this.options.silent)console.error(t);else throw Error(t)}},J=class{options;parser;constructor(e){this.options=e||b}space(e){return``}code({text:e,lang:t,escaped:n}){let r=(t||``).match(T.notSpaceStart)?.[0],i=e.replace(T.endingNewline,``)+`
`;return r?`<pre><code class="language-`+W(r)+`">`+(n?i:W(i,!0))+`</code></pre>
`:`<pre><code>`+(n?i:W(i,!0))+`</code></pre>
`}blockquote({tokens:e}){return`<blockquote>
${this.parser.parse(e)}</blockquote>
`}html({text:e}){return e}def(e){return``}heading({tokens:e,depth:t}){return`<h${t}>${this.parser.parseInline(e)}</h${t}>
`}hr(e){return`<hr>
`}list(e){let t=e.ordered,n=e.start,r=``;for(let t=0;t<e.items.length;t++){let n=e.items[t];r+=this.listitem(n)}let i=t?`ol`:`ul`,a=t&&n!==1?` start="`+n+`"`:``;return`<`+i+a+`>
`+r+`</`+i+`>
`}listitem(e){return`<li>${this.parser.parse(e.tokens)}</li>
`}checkbox({checked:e}){return`<input `+(e?`checked="" `:``)+`disabled="" type="checkbox"> `}paragraph({tokens:e}){return`<p>${this.parser.parseInline(e)}</p>
`}table(e){let t=``,n=``;for(let t=0;t<e.header.length;t++)n+=this.tablecell(e.header[t]);t+=this.tablerow({text:n});let r=``;for(let t=0;t<e.rows.length;t++){let i=e.rows[t];n=``;for(let e=0;e<i.length;e++)n+=this.tablecell(i[e]);r+=this.tablerow({text:n})}return r&&=`<tbody>${r}</tbody>`,`<table>
<thead>
`+t+`</thead>
`+r+`</table>
`}tablerow({text:e}){return`<tr>
${e}</tr>
`}tablecell(e){let t=this.parser.parseInline(e.tokens),n=e.header?`th`:`td`;return(e.align?`<${n} align="${e.align}">`:`<${n}>`)+t+`</${n}>
`}strong({tokens:e}){return`<strong>${this.parser.parseInline(e)}</strong>`}em({tokens:e}){return`<em>${this.parser.parseInline(e)}</em>`}codespan({text:e}){return`<code>${W(e,!0)}</code>`}br(e){return`<br>`}del({tokens:e}){return`<del>${this.parser.parseInline(e)}</del>`}link({href:e,title:t,tokens:n}){let r=this.parser.parseInline(n),i=nt(e);if(i===null)return r;e=i;let a=`<a href="`+e+`"`;return t&&(a+=` title="`+W(t)+`"`),a+=`>`+r+`</a>`,a}image({href:e,title:t,text:n,tokens:r}){r&&(n=this.parser.parseInline(r,this.parser.textRenderer));let i=nt(e);if(i===null)return W(n);e=i;let a=`<img src="${e}" alt="${W(n)}"`;return t&&(a+=` title="${W(t)}"`),a+=`>`,a}text(e){return`tokens`in e&&e.tokens?this.parser.parseInline(e.tokens):`escaped`in e&&e.escaped?e.text:W(e.text)}},Y=class{strong({text:e}){return e}em({text:e}){return e}codespan({text:e}){return e}del({text:e}){return e}html({text:e}){return e}text({text:e}){return e}link({text:e}){return``+e}image({text:e}){return``+e}br(){return``}checkbox({raw:e}){return e}},X=class e{options;renderer;textRenderer;constructor(e){this.options=e||b,this.options.renderer=this.options.renderer||new J,this.renderer=this.options.renderer,this.renderer.options=this.options,this.renderer.parser=this,this.textRenderer=new Y}static parse(t,n){return new e(n).parse(t)}static parseInline(t,n){return new e(n).parseInline(t)}parse(e){this.renderer.parser=this;let t=``;for(let n=0;n<e.length;n++){let r=e[n];if(this.options.extensions?.renderers?.[r.type]){let e=r,n=this.options.extensions.renderers[e.type].call({parser:this},e);if(n!==!1||![`space`,`hr`,`heading`,`code`,`table`,`blockquote`,`list`,`checkbox`,`html`,`def`,`paragraph`,`text`].includes(e.type)){t+=n||``;continue}}let i=r;switch(i.type){case`space`:t+=this.renderer.space(i);break;case`hr`:t+=this.renderer.hr(i);break;case`heading`:t+=this.renderer.heading(i);break;case`code`:t+=this.renderer.code(i);break;case`table`:t+=this.renderer.table(i);break;case`blockquote`:t+=this.renderer.blockquote(i);break;case`list`:t+=this.renderer.list(i);break;case`checkbox`:t+=this.renderer.checkbox(i);break;case`html`:t+=this.renderer.html(i);break;case`def`:t+=this.renderer.def(i);break;case`paragraph`:t+=this.renderer.paragraph(i);break;case`text`:t+=this.renderer.text(i);break;default:{let e=`Token with "`+i.type+`" type was not found.`;if(this.options.silent)return console.error(e),``;throw Error(e)}}}return t}parseInline(e,t=this.renderer){this.renderer.parser=this;let n=``;for(let r=0;r<e.length;r++){let i=e[r];if(this.options.extensions?.renderers?.[i.type]){let e=this.options.extensions.renderers[i.type].call({parser:this},i);if(e!==!1||![`escape`,`html`,`link`,`image`,`checkbox`,`strong`,`em`,`codespan`,`br`,`del`,`text`].includes(i.type)){n+=e||``;continue}}let a=i;switch(a.type){case`escape`:n+=t.text(a);break;case`html`:n+=t.html(a);break;case`link`:n+=t.link(a);break;case`image`:n+=t.image(a);break;case`checkbox`:n+=t.checkbox(a);break;case`strong`:n+=t.strong(a);break;case`em`:n+=t.em(a);break;case`codespan`:n+=t.codespan(a);break;case`br`:n+=t.br(a);break;case`del`:n+=t.del(a);break;case`text`:n+=t.text(a);break;default:{let e=`Token with "`+a.type+`" type was not found.`;if(this.options.silent)return console.error(e),``;throw Error(e)}}}return n}},Z=class{options;block;constructor(e){this.options=e||b}static passThroughHooks=new Set([`preprocess`,`postprocess`,`processAllTokens`,`emStrongMask`]);static passThroughHooksRespectAsync=new Set([`preprocess`,`postprocess`,`processAllTokens`]);preprocess(e){return e}postprocess(e){return e}processAllTokens(e){return e}emStrongMask(e){return e}provideLexer(e=this.block){return e?q.lex:q.lexInline}provideParser(e=this.block){return e?X.parse:X.parseInline}},Q=new class{defaults=y();options=this.setOptions;parse=this.parseMarkdown(!0);parseInline=this.parseMarkdown(!1);Parser=X;Renderer=J;TextRenderer=Y;Lexer=q;Tokenizer=K;Hooks=Z;constructor(...e){this.use(...e)}walkTokens(e,t){let n=[];for(let r of e)switch(n=n.concat(t.call(this,r)),r.type){case`table`:{let e=r;for(let r of e.header)n=n.concat(this.walkTokens(r.tokens,t));for(let r of e.rows)for(let e of r)n=n.concat(this.walkTokens(e.tokens,t));break}case`list`:{let e=r;n=n.concat(this.walkTokens(e.items,t));break}default:{let e=r;this.defaults.extensions?.childTokens?.[e.type]?this.defaults.extensions.childTokens[e.type].forEach(r=>{let i=e[r].flat(1/0);n=n.concat(this.walkTokens(i,t))}):e.tokens&&(n=n.concat(this.walkTokens(e.tokens,t)))}}return n}use(...e){let t=this.defaults.extensions||{renderers:{},childTokens:{}};return e.forEach(e=>{let n={...e};if(n.async=this.defaults.async||n.async||!1,e.extensions&&(e.extensions.forEach(e=>{if(!e.name)throw Error(`extension name required`);if(`renderer`in e){let n=t.renderers[e.name];n?t.renderers[e.name]=function(...t){let r=e.renderer.apply(this,t);return r===!1&&(r=n.apply(this,t)),r}:t.renderers[e.name]=e.renderer}if(`tokenizer`in e){if(!e.level||e.level!==`block`&&e.level!==`inline`)throw Error(`extension level must be 'block' or 'inline'`);let n=t[e.level];n?n.unshift(e.tokenizer):t[e.level]=[e.tokenizer],e.start&&(e.level===`block`?t.startBlock?t.startBlock.push(e.start):t.startBlock=[e.start]:e.level===`inline`&&(t.startInline?t.startInline.push(e.start):t.startInline=[e.start]))}`childTokens`in e&&e.childTokens&&(t.childTokens[e.name]=e.childTokens)}),n.extensions=t),e.renderer){let t=this.defaults.renderer||new J(this.defaults);for(let n in e.renderer){if(!(n in t))throw Error(`renderer '${n}' does not exist`);if([`options`,`parser`].includes(n))continue;let r=n,i=e.renderer[r],a=t[r];t[r]=(...e)=>{let n=i.apply(t,e);return n===!1&&(n=a.apply(t,e)),n||``}}n.renderer=t}if(e.tokenizer){let t=this.defaults.tokenizer||new K(this.defaults);for(let n in e.tokenizer){if(!(n in t))throw Error(`tokenizer '${n}' does not exist`);if([`options`,`rules`,`lexer`].includes(n))continue;let r=n,i=e.tokenizer[r],a=t[r];t[r]=(...e)=>{let n=i.apply(t,e);return n===!1&&(n=a.apply(t,e)),n}}n.tokenizer=t}if(e.hooks){let t=this.defaults.hooks||new Z;for(let n in e.hooks){if(!(n in t))throw Error(`hook '${n}' does not exist`);if([`options`,`block`].includes(n))continue;let r=n,i=e.hooks[r],a=t[r];t[r]=Z.passThroughHooks.has(n)?e=>{if(this.defaults.async&&Z.passThroughHooksRespectAsync.has(n))return(async()=>{let n=await i.call(t,e);return a.call(t,n)})();let r=i.call(t,e);return a.call(t,r)}:(...e)=>{if(this.defaults.async)return(async()=>{let n=await i.apply(t,e);return n===!1&&(n=await a.apply(t,e)),n})();let n=i.apply(t,e);return n===!1&&(n=a.apply(t,e)),n}}n.hooks=t}if(e.walkTokens){let t=this.defaults.walkTokens,r=e.walkTokens;n.walkTokens=function(e){let n=[];return n.push(r.call(this,e)),t&&(n=n.concat(t.call(this,e))),n}}this.defaults={...this.defaults,...n}}),this}setOptions(e){return this.defaults={...this.defaults,...e},this}lexer(e,t){return q.lex(e,t??this.defaults)}parser(e,t){return X.parse(e,t??this.defaults)}parseMarkdown(e){return(t,n)=>{let r={...n},i={...this.defaults,...r},a=this.onError(!!i.silent,!!i.async);if(this.defaults.async===!0&&r.async===!1)return a(Error(`marked(): The async option was set to true by an extension. Remove async: false from the parse options object to return a Promise.`));if(typeof t>`u`||t===null)return a(Error(`marked(): input parameter is undefined or null`));if(typeof t!=`string`)return a(Error(`marked(): input parameter is of type `+Object.prototype.toString.call(t)+`, string expected`));if(i.hooks&&(i.hooks.options=i,i.hooks.block=e),i.async)return(async()=>{let n=i.hooks?await i.hooks.preprocess(t):t,r=await(i.hooks?await i.hooks.provideLexer(e):e?q.lex:q.lexInline)(n,i),a=i.hooks?await i.hooks.processAllTokens(r):r;i.walkTokens&&await Promise.all(this.walkTokens(a,i.walkTokens));let o=await(i.hooks?await i.hooks.provideParser(e):e?X.parse:X.parseInline)(a,i);return i.hooks?await i.hooks.postprocess(o):o})().catch(a);try{i.hooks&&(t=i.hooks.preprocess(t));let n=(i.hooks?i.hooks.provideLexer(e):e?q.lex:q.lexInline)(t,i);i.hooks&&(n=i.hooks.processAllTokens(n)),i.walkTokens&&this.walkTokens(n,i.walkTokens);let r=(i.hooks?i.hooks.provideParser(e):e?X.parse:X.parseInline)(n,i);return i.hooks&&(r=i.hooks.postprocess(r)),r}catch(e){return a(e)}}}onError(e,t){return n=>{if(n.message+=`
Please report this to https://github.com/markedjs/marked.`,e){let e=`<p>An error occurred:</p><pre>`+W(n.message+``,!0)+`</pre>`;return t?Promise.resolve(e):e}if(t)return Promise.reject(n);throw n}}};function $(e,t){return Q.parse(e,t)}$.options=$.setOptions=function(e){return Q.setOptions(e),$.defaults=Q.defaults,x($.defaults),$},$.getDefaults=y,$.defaults=b;function lt(...e){return Q.use(...e),$.defaults=Q.defaults,x($.defaults),$}$.use=lt,$.walkTokens=function(e,t){return Q.walkTokens(e,t)},$.parseInline=Q.parseInline,$.Parser=X,$.parser=X.parse,$.Renderer=J,$.TextRenderer=Y,$.Lexer=q,$.lexer=q.lex,$.Tokenizer=K,$.Hooks=Z,$.parse=$,$.options,$.setOptions,$.walkTokens,$.parseInline,X.parse,q.lex;var ut=`# POL-2000 : Méthodologie quantitative

**Plan de cours — Automne 2026**

Université Laval · Faculté des sciences sociales · Département de science politique

---

## Identification

| | |
|---|---|
| **Sigle** | POL-2000 — Méthodologie quantitative |
| **NRC** | 87892 |
| **Session** | Automne 2026 (31 août au 11 décembre 2026) |
| **Crédits** | 3 |
| **Temps consacré** | 3-0-6 |
| **Formule d'enseignement** | **En présentiel** |
| **Plage horaire** | **Jeudi, 15h30 à 18h20** |
| **Local** | Pavillon Charles-De Koninck, DKN-3159 |
| **Site de cours** | monPortail — *lien à confirmer* |

**Préalables :** ((POL 1000 à 4999, crédits exigés : 9 ET POL 1010) OU SOC 1005 OU
SVS 1004 OU ANT 1002 OU LNG 1002 OU ORT 1001 OU GPL 1001 OU GPL 1009)

## Coordonnées et disponibilités

**Laurence-Olivier M. Foisy** — Enseignant  
Courriel : [mail@mfoisy.com](mailto:mail@mfoisy.com)  
Disponibilités : sur rendez-vous, ainsi que lors des semaines de rencontres
individuelles prévues au calendrier. Écrivez-moi pour convenir d'un moment.

**Auxiliaires d'enseignement :** *à confirmer*

### Soutien technique

CSTIP — Centre de services en TI et pédagogie  
Pavillon Charles-De Koninck, local 0248 · [aide@cstip.ulaval.ca](mailto:aide@cstip.ulaval.ca)  
418-656-2131 poste 405222 · 418-656-5222

---

## Description du cours

### Introduction

Ce cours s'adresse aux étudiant.e.s du premier cycle souhaitant se familiariser
avec un aspect fondamental de la recherche en sciences sociales : l'analyse de
données portant sur un grand nombre de cas. Vous allez apprendre les différentes
techniques statistiques qui permettent de décrire une variable, de dégager les
relations entre deux variables ou plus et de tirer des conclusions sur les
caractéristiques d'une population à partir de l'observation d'un échantillon,
sans toutefois approfondir les fondements mathématiques de ces techniques. Vous
apprendrez aussi le langage de programmation R, les limites de l'analyse causale
et les techniques pour y outrepasser.

**Préalables mathématiques :** aucun cours de mathématique ni de statistique en
dehors du curriculum obligatoire du niveau secondaire n'est requis.

### Buts et objectifs généraux

Au terme de ce cours, l'étudiant.e sera en mesure de :

- maîtriser les différents concepts et techniques propres à l'analyse statistique;
- utiliser les fonctions de base du langage de programmation R et du logiciel
  Positron pour le traitement de données;
- comprendre et critiquer des articles scientifiques à l'aide de techniques
  statistiques;
- comprendre la logique de l'analyse causale et ses limites;
- concevoir et réaliser son propre projet de recherche.

### Contenu du cours

Le cours est divisé en trois thématiques.

**Première partie — Introduction aux concepts statistiques de base**

- Comment opérationnaliser une question de recherche de façon quantitative
- Les types de variables
- Les distributions de fréquences et de pourcentages
- Les mesures de tendance centrale
- Les mesures de variation

**Deuxième partie — Régression linéaire bivariée et multiple**

- Comprendre la logique derrière la régression linéaire
- Savoir interpréter des coefficients de variables continues, binaires et catégoriques
- Savoir interpréter le niveau de signification statistique
- Savoir interpréter les tableaux bivariés
- La régression et la corrélation simple avec R
- Interpréter des coefficients lorsqu'il y a plus d'une variable explicative
- L'analyse tabulaire multivariée

**Troisième partie — L'inférence causale**

- Comprendre le problème fondamental de l'inférence causale
- Comprendre le concept de variables de contrôle et savoir quelles variables
  ajouter (ou pas) à une régression
- Comprendre la pertinence des graphes orientés acycliques (GOA) pour outrepasser
  ces problèmes
- Comprendre les biais possibles et leurs effets potentiels sur la régression linéaire

### Approche pédagogique

Chaque séance suit la forme d'un cours magistral **en classe**. Les échanges entre
les étudiant.e.s et l'enseignant sont fortement encouragés : c'est l'avantage
principal du format en présentiel, et j'ai l'intention de m'en servir. À cette fin,
les étudiant.e.s sont incité.e.s à faire les lectures indiquées avant chaque séance.

Dans l'objectif de mettre leurs connaissances en application, **les étudiant.e.s
doivent apporter leur ordinateur portable à chaque séance**. À partir de la séance 2,
la plupart des séances comportent des démonstrations en direct avec R et Positron,
que vous pourrez suivre sur votre propre ordinateur.

Chaque semaine présente :

- les objectifs spécifiques;
- les lectures préalables;
- les exercices Datacamp;
- les diapositives du cours.

Un glossaire des notions clefs accompagne le cours.

### Ouvrage de référence

Aucune lecture obligatoire n'est imposée dans ce cours. L'ouvrage suivant sert
toutefois de **référence pour l'ensemble de la session** : il couvre la matière vue
en classe et vous y trouverez, au besoin, une présentation plus détaillée de chaque
notion.

Arel-Bundock, Vincent. 2021. *Analyse causale et méthodes quantitatives : Une
introduction avec R, Stata et SPSS*. Presses de l'Université de Montréal.

Le livre est **disponible gratuitement en format PDF** sur le site des Presses de
l'Université de Montréal. Une version papier peut être achetée chez Coop Zone par
celles et ceux qui le souhaitent.

### Informations concernant les logiciels R et Positron

Les logiciels statistiques obligatoires dans ce cours sont **R** et **Positron**. R
est un langage de programmation gratuit de plus en plus utilisé par les chercheurs
quantitatifs en sciences sociales, mais aussi par de nombreux analystes de données.
Positron est un environnement de développement gratuit et libre, conçu par Posit,
qui vous permet d'utiliser R plus facilement. Il est
nécessaire de télécharger ces deux logiciels dans le cadre de ce cours.

La séance d'introduction à R a lieu dès la **semaine 2 (jeudi 10 septembre 2026)**,
et une seconde séance consacrée à la préparation des données avec R suit à la
semaine 4. Il est essentiel d'avoir installé les deux logiciels avant la séance 2 :
la marche à suivre sera présentée à la séance 1.

Des devoirs sur la plateforme datacamp.com vous seront proposés chaque semaine pour
développer rapidement vos compétences en R. Je vous recommande donc fortement
d'installer R et Positron dès le début de la session.

### Datacamp

Des devoirs obligatoires vous seront partagés chaque semaine sur Datacamp. Pour
obtenir votre 10 % complet, vous devrez réaliser tous les devoirs proposés pendant
la première moitié de la session avant le **25 octobre 2026 à 23h59** (premier 5 %).
Les devoirs de la seconde moitié de la session — en incluant ceux de la première
moitié — devront être réalisés avant le **18 décembre 2026 à 23h59** (deuxième 5 %).

### Utilisation de l'intelligence artificielle générative

Les outils d'intelligence artificielle générative (ChatGPT, Claude, Gemini, Copilot
et autres) font désormais partie de l'environnement de travail de toute personne qui
analyse des données. Ce cours ne les interdit pas : il vous apprend à vous en servir
correctement.

- **Permis, à condition de le déclarer :** obtenir de l'aide pour écrire, comprendre
  ou déboguer du code R.
- **Non permis :** l'interprétation des résultats et la rédaction des travaux. Ce que
  vous affirmez, vous devez pouvoir le défendre.
- **Chaque évaluation précise ses propres consignes** quant à l'utilisation permise de
  ces outils.
- **Les examens 2 et 3 se font sur papier, à livre ouvert**, précisément pour cette
  raison : vos notes sont permises, aucun appareil ne l'est.

Deux séances abordent directement ces outils : la séance 2 (utiliser un assistant
d'IA pour apprendre R) et la séance 9 (produire, puis vérifier, une analyse complète
réalisée par un agent d'IA). La règle de base tient en une question : *l'aurais-je
accepté d'un assistant humain sans vérifier son travail ?*

### Politique de retard

Une pénalité de **10 % par jour** de la note obtenue sera appliquée à toute
évaluation remise en retard sans justification valable. Après trois jours de retard,
la note sera de 0.

---

## Contenu et activités

Le tableau ci-dessous présente les séances prévues dans le cadre du cours. La session
d'automne 2026 compte **14 séances** le jeudi, aucune ne tombant sur un jour férié.

| Séance | Date | Titre |
|---|---|---|
| 1 | jeudi 3 septembre 2026 | Introduction et les éléments fondamentaux de la recherche |
| 2 | jeudi 10 septembre 2026 | Introduction à R et à Positron |
| 3 | jeudi 17 septembre 2026 | Les statistiques descriptives et la visualisation des données |
| 4 | jeudi 24 septembre 2026 | Préparer ses données avec R |
| 5 | jeudi 1er octobre 2026 | L'inférence statistique |
| 6 | jeudi 8 octobre 2026 | Rencontres individuelles — aucun cours (travail de mi-session) |
| 7 | jeudi 15 octobre 2026 | La régression linéaire simple |
| 8 | jeudi 22 octobre 2026 | La régression linéaire multiple |
| — | jeudi 29 octobre 2026 | **Semaine de lecture — aucun cours** (26 au 30 octobre) |
| 9 | jeudi 5 novembre 2026 | De la question au tableau de régression : à la main, puis avec l'IA |
| 10 | jeudi 12 novembre 2026 | Le problème fondamental de l'inférence causale, puis **Examen 2** (17h20 à 18h20) |
| 11 | jeudi 19 novembre 2026 | Les graphes orientés acycliques (GOA) |
| 12 | jeudi 26 novembre 2026 | Rencontres individuelles — aucun cours (retour sur l'examen 2, travail final) |
| 13 | jeudi 3 décembre 2026 | Les biais |
| 14 | jeudi 10 décembre 2026 | Les expériences et révision, puis **Examen 3** (17h20 à 18h20) |

**Remises et échéances**

- **Examen 1** — ouvre le jeudi 24 septembre 2026, remise au plus tard le
  **dimanche 4 octobre 2026 à 23h59**
- **Travail de mi-session** et **Datacamp (1re partie)** — **dimanche 25 octobre 2026 à 23h59**
- **Travail final** et **Datacamp (1re + 2e partie)** — **vendredi 18 décembre 2026 à 23h59**

**Dates institutionnelles à retenir**

- Fin de la période de modification du choix de cours : mardi 8 septembre 2026
- Abandon avec remboursement : lundi 14 septembre 2026
- Abandon sans mention d'échec et sans remboursement : lundi 9 novembre 2026
- Semaine de lecture : 26 au 30 octobre 2026
- Fin des cours : vendredi 11 décembre 2026

---

## Évaluations et résultats

### Liste des évaluations

| Regroupement | Évaluation | Date | Mode | Pondération |
|---|---|---|---|---|
| **Examens** | | | | **45 %** |
| | Examen 1 — Analyser des données avec R | du 24 sept. au 4 oct. 2026, 23h59 | Individuel | 15 % |
| | Examen 2 — Les statistiques descriptives | jeudi 12 nov. 2026, 17h20–18h20 | Individuel | 15 % |
| | Examen 3 — Régressions linéaires simple et multiple | jeudi 10 déc. 2026, 17h20–18h20 | Individuel | 15 % |
| **Travaux** | | | | **45 %** |
| | Travail de mi-session | dim. 25 oct. 2026, 23h59 | Individuel | 20 % |
| | Travail final | ven. 18 déc. 2026, 23h59 | Individuel | 25 % |
| **Exercices** | | | | **10 %** |
| | Datacamp (1re partie) | dim. 25 oct. 2026, 23h59 | Individuel | 5 % |
| | Datacamp (1re + 2e partie) | ven. 18 déc. 2026, 23h59 | Individuel | 5 % |

Ce cours comporte quatre types d'évaluations :

1. **deux examens en classe et un à distance** (45 %);
2. **travail de mi-session** (20 %);
3. **travail final** (25 %);
4. **devoirs sur Datacamp** (10 %).

Des questionnaires facultatifs vous permettent de mettre vos connaissances en
application. Ils ne comptent pas dans votre note finale.

### Informations détaillées

#### Examen 1 — Analyser des données avec R (15 %)

| | |
|---|---|
| **Date** | Du jeudi 24 septembre 2026 au dimanche 4 octobre 2026 à 23h59 |
| **Mode de travail** | Individuel |
| **Remise** | Boîte de dépôt sur le site de cours |

Examen pratique à faire chez vous, sur ordinateur, à la suite des séances 2 et 4
consacrées à R. Il évalue votre capacité à importer, manipuler et décrire des
données avec R et Positron.

#### Examen 2 — Les statistiques descriptives (15 %)

| | |
|---|---|
| **Date** | Jeudi 12 novembre 2026, de 17h20 à 18h20 |
| **Mode de travail** | Individuel |
| **Lieu** | **En classe, au local du cours** |
| **Matériel autorisé** | Papier, crayon et vos notes personnelles — l'examen est à livre ouvert. Aucun appareil électronique. |

Examen d'une heure écrit **pendant la période de cours habituelle**. Aucune
inscription à un centre d'examen n'est requise : le cours étant donné en présentiel,
l'examen se déroule directement en classe. La séance commence par le cours
(15h30 à 17h05), suivi d'une pause de 15 minutes; l'examen occupe la dernière heure.

#### Examen 3 — Régressions linéaires simple et multiple (15 %)

| | |
|---|---|
| **Date** | Jeudi 10 décembre 2026, de 17h20 à 18h20 |
| **Mode de travail** | Individuel |
| **Lieu** | **En classe, au local du cours** |
| **Matériel autorisé** | Papier, crayon et vos notes personnelles — l'examen est à livre ouvert. Aucun appareil électronique. |

Examen d'une heure écrit en classe lors de la dernière séance. La séance commence par
la matière sur les expériences et la révision de fin de session (15h30 à 17h05), suivie
d'une pause de 15 minutes; l'examen occupe la dernière heure.

#### Travail de mi-session (20 %)

| | |
|---|---|
| **Date de remise** | Dimanche 25 octobre 2026 à 23h59 |
| **Mode de travail** | Individuel |
| **Remise** | Boîte de dépôt, format PDF |

Le travail de mi-session est une version courte de votre travail final. Il se veut
une première version simplifiée, à l'image d'un devis de recherche, pour obtenir une
rétroaction de ma part avant la remise finale. La remise est fixée juste avant la
semaine de lecture afin que vous receviez cette rétroaction à temps pour la suite.

Vous devrez :

- concevoir une question de recherche mettant en relation une variable dépendante et
  une variable indépendante;
- présenter une courte revue de la littérature avec des théories permettant de dériver
  des hypothèses testables empiriquement;
- formuler une ou des hypothèses (et leur hypothèse nulle) sur la relation entre les
  deux variables;
- présenter la base de données et les variables sélectionnées pour tester les hypothèses;
- justifier la pertinence et l'originalité de la question de recherche;
- ajouter la contribution souhaitée à la littérature scientifique;
- conclure par une justification personnelle du choix de la recherche.

La présentation et la citation des sources seront prises en compte dans votre note.
Les consignes complètes seront déposées sur le site de cours après la semaine 4.

#### Travail final (25 %)

| | |
|---|---|
| **Date de remise** | Vendredi 18 décembre 2026 à 23h59 |
| **Mode de travail** | Individuel |
| **Remise** | Boîte de dépôt, format PDF |

Le travail final est la création d'un projet de recherche et a pour objectif de vous
initier aux étapes de la recherche quantitative. Tou.te.s les étudiant.e.s travaillent
avec une banque de données fournie. À partir de cette banque de données, vous devrez :

- concevoir une question de recherche mettant en relation une variable dépendante et
  une variable indépendante;
- présenter une revue de la littérature bonifiée avec des théories permettant de
  dériver des hypothèses testables empiriquement;
- formuler une hypothèse (et une hypothèse nulle) sur la relation entre vos deux variables;
- présenter la base de données et les variables sélectionnées pour tester les hypothèses;
- inclure un **graphe orienté acyclique (GOA)**;
- présenter des **statistiques descriptives**;
- exécuter une **régression linéaire** pour estimer la relation entre les variables et
  présenter le tableau de régression;
- **interpréter les résultats**;
- considérer les **biais potentiels**, discuter des limites de votre analyse et réfléchir
  à une méthode alternative (dans une recherche future) pour estimer l'effet causal qui
  vous intéresse.

Vous devrez vous servir de l'interface **Positron** pour réaliser ce travail. La
présentation et la citation des sources seront prises en compte dans votre note.

#### Datacamp (2 × 5 %)

| | |
|---|---|
| **1re partie** | Dimanche 25 octobre 2026 à 23h59 — 5 % |
| **1re + 2e partie** | Vendredi 18 décembre 2026 à 23h59 — 5 % |
| **Remise** | datacamp.com |

Des devoirs obligatoires vous sont partagés chaque semaine. Pour obtenir la totalité
des points, tous les devoirs de la période concernée doivent être complétés à
l'échéance.

### Barème de conversion

| Cote | % minimum | % maximum | | Cote | % minimum | % maximum |
|---|---|---|---|---|---|---|
| A+ | 90 | 100 | | C+ | 66 | 69,99 |
| A | 85 | 89,99 | | C | 63 | 65,99 |
| A- | 80 | 84,99 | | C- | 60 | 62,99 |
| B+ | 76 | 79,99 | | D+ | 55 | 59,99 |
| B | 73 | 75,99 | | D | 50 | 54,99 |
| B- | 70 | 72,99 | | E | 0 | 49,99 |

### Règlements et politiques institutionnels

Les règlements institutionnels de l'Université Laval s'appliquent, notamment le
Règlement disciplinaire à l'intention des étudiants de l'Université Laval en matière
de plagiat et de fraude académique.

### Étudiant.e.s ayant une situation de handicap liée à une limitation fonctionnelle

Les étudiant.e.s ayant une situation de handicap liée à une limitation fonctionnelle
sont invité.e.s à communiquer avec le Centre d'aide aux étudiants pour mettre en place
les mesures d'accommodement nécessaires. Écrivez-moi également afin que nous puissions
en discuter.

---

## Matériel didactique

### Matériel obligatoire

- **R** — [cran.r-project.org](https://cran.r-project.org)
- **Positron** — [positron.posit.co](https://positron.posit.co/download.html)
- Un **ordinateur portable** à apporter à chaque séance.

### Ouvrage de référence (non obligatoire)

- Arel-Bundock, Vincent. 2021. *Analyse causale et méthodes quantitatives : Une
  introduction avec R, Stata et SPSS*. Presses de l'Université de Montréal.
  (gratuit en PDF)

### Spécifications technologiques

R et Positron fonctionnent sous Windows, macOS et Linux. Si vous n'avez pas accès à un
ordinateur portable, communiquez avec moi dès le début de la session : des solutions
existent.

---

## Ce qui change par rapport à l'offre précédente (Hiver 2024)

Ce plan de cours reprend la structure de l'offre H24 en l'adaptant à l'enseignement
en présentiel :

| | Hiver 2024 | Automne 2026 |
|---|---|---|
| Formule | À distance, classe virtuelle synchrone | **En présentiel** |
| Horaire | Mercredi 15h30–18h20 | **Jeudi 15h30–18h20** |
| Examens 2 et 3 | En soirée, dans un centre d'examen à réserver | **En classe, pendant la période de cours** |
| Rencontres individuelles | Deux semaines dédiées | Deux semaines dédiées (semaines 6 et 12) + disponibilités sur rendez-vous |
| Semaines d'examen | — | Le cours d'abord (1 h 35), une pause, puis l'examen (1 h) |
| Nombre de séances | 15 semaines | 14 séances (aucune ne tombe sur un jour férié) |
| Introduction à R | Semaine 4 | **Semaine 2**, suivie d'une seconde séance sur la préparation des données (semaine 4) |
| Livre | Obligatoire | Ouvrage de référence, non obligatoire |
| Intelligence artificielle générative | — | Abordée aux séances 2 et 9; consignes précisées pour chaque évaluation |

La structure des évaluations, leurs pondérations et les exercices Datacamp demeurent
inchangés.
`,dt=h({load:()=>pt,prerender:()=>!0}),ft=e=>e.toLowerCase().normalize(`NFD`).replace(/[\u0300-\u036f]/g,``).replace(/[^a-z0-9]+/g,`-`).replace(/^-|-$/g,``);function pt(){let e=[];$.use({renderer:{heading({tokens:t,depth:n}){let r=this.parser.parseInline(t),i=t.map(e=>e.raw).join(``),a=ft(i);return n===2&&e.push({id:a,text:i}),`<h${n} id="${a}">${r}</h${n}>\n`}},gfm:!0});let t=ut.slice(ut.indexOf(`
## `));return{html:$.parse(t),toc:e}}var mt=o(`<meta name="description" content="Plan de cours POL-2000 Méthodologie quantitative, Université Laval, automne 2026."/> <link rel="icon" type="image/svg+xml"/>`,1),ht=o(`<li class="svelte-1oh9q7c"><a class="svelte-1oh9q7c"> </a></li>`),gt=o(`<!> <main class="svelte-1oh9q7c"><header class="tete svelte-1oh9q7c"><p class="sur monte svelte-1oh9q7c"> </p> <h1 class="monte svelte-1oh9q7c">Plan de cours</h1> <hr class="filet monte"/> <p class="lead monte"> </p> <div class="actions monte svelte-1oh9q7c"><a class="bouton plein" rel="noopener">Télécharger le PDF <span class="fl">↓</span></a> <a class="bouton">Retour au site <span class="fl">→</span></a></div></header> <div class="corps svelte-1oh9q7c"><nav class="sommaire svelte-1oh9q7c" aria-label="Sommaire"><p class="etiq gris">Sommaire</p> <ol class="svelte-1oh9q7c"></ol></nav> <article class="prose svelte-1oh9q7c"></article></div></main> <!>`,1);function _t(o,h){c(h,!0);let y=[{href:`${_}/#seances`,texte:`Séances`},{href:`${_}/#evaluations`,texte:`Évaluations`},{href:`${_}/${ie.syllabusPdf}`,texte:`PDF`,phare:!0}];var b=gt();d(`1oh9q7c`,e=>{var i=mt(),a=s(ne(i),2);r(()=>g(a,`href`,`${_??``}/img/pol2000_logo.svg`)),n(()=>{t.title=`Plan de cours · POL-2000 · Automne 2026`}),u(e,i)});var x=ne(b);re(x,{get liens(){return y},retour:!0});var S=s(x,2),C=a(S),w=a(C),oe=e(w),T=s(w,6),se=e(T),E=s(T,2),D=a(E),O=s(D,2);f(E),f(C);var k=s(C,2),A=a(k),j=s(a(A),2);m(j,21,()=>h.data.toc,p,(t,n)=>{var o=ht(),s=a(o),c=e(s,!0);f(o),r(()=>{g(s,`href`,`#${i(n).id??``}`),te(c,i(n).text)}),u(t,o)}),f(j),f(A);var M=s(A,2);ee(M,()=>h.data.html,!0),f(M),f(k),f(S);var ce=s(S,2);ae(ce,{}),r(()=>{te(oe,`${v.sigle??``} · ${v.session??``} · NRC ${v.nrc??``}`),te(se,`${v.titre??``}. Université Laval, Faculté des sciences sociales, Département de science politique. Le ${v.jour??``}, de ${v.heures??``}, au ${v.local??``}.`),g(D,`href`,`${_??``}/${ie.syllabusPdf??``}`),g(O,`href`,`${_??``}/`)}),u(o,b),l()}export{_t as component,dt as universal};