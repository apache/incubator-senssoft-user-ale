---
layout: page
title: JavaScript Helper Library
prev_section: drafts
next_section: variables
permalink: /helper_libs/javascript/
---

Due to the high number of Data Analytic tools using web technologies, a JavaScript helper library was created to aid developers in instrumenting their JavaScript tools with logging capabilities.

The current version of the JavaScript API uses <a href="https://developer.mozilla.org/en-US/docs/Web/API/Worker">Web Workers</a>, this allows logging to happen as a background process, and should have minimal interference with other processes that are happening on the web client.

----

## Getting Started

###Download both the latest logging library and the latest worker library from Github <a href="https://github.com/draperlaboratory/User-ALE/tree/master/helper-libs/javascript">here.</a>

###Include the logging library
  {% highlight html %}
    <script src="js/draper.activity_logger-2.1.1.js"></script>;
  {% endhighlight %}

###Instantiate the Logger
  {% highlight javascript %}
// web worker url
var worker = 'js/draper.activity_worker-2.1.1.js'
var ac = new activityLogger(worker);
.testing(true) // simulate POST, won't send log
.echo(true) // log to console
.mute(['SYS']); // don't log SYSTEM actions
  {% endhighlight %}

<div class="alert alert-warning" role="alert">
  If you plan to distribute software that is instrumented using User-ALE, please set testing=true to ensure that logging is not automatically turned on.
</div>

###Register the Logger
  {% highlight javascript %}
ac.registerActivityLogger(
"http://xd-draper.xdata.data-tactics-corp.com:1337",
"my-component",
"v0.1"
);
  {% endhighlight %}

###Log a User Activity
  {% highlight javascript %}
$('#button').mouseenter(function() {
  ac.logUserActivity(
  'User hovered over element to read popup', // description
  'hover_start', // activity_code
  ac.WF_EXPLORE // workflow State
  );
})
  {% endhighlight %}

----

##Function Reference
<b class="function-name">activityLogger</b><code class="function-usage">new activityLogger(workerUrl)</code>
<br>
<p>Instantiate a new activityLogger.  The activityLogger accepts a <b>workerUrl</b> that points to your local copy of the worker library.  This file contains the Web Worker component that makes XHR calls as a background process.</p>
{% highlight javascript %}
// web worker url
var worker = 'js/draper.activity_worker-2.1.1.js'
var ac = new activityLogger(worker);
{% endhighlight %}
<hr>
<b class="function-name">testing</b><code class="function-usage">ac.testing(true/false)</code>
<br>
<p>Set to true to disable XHR logging to remote server and  to false to enable XHR logging to remote server.</p>
<div class="alert alert-warning" role="alert">
  If you plan to distribute software that is instrumented using User-ALE, please set testing=true to ensure that logging is not automatically turned on.
</div>
<hr>
<b class="function-name">echo</b><code class="function-usage">ac.echo(true/false)</code>
<br>
<p>Set to true to echo all logs to console and to false to silence console messages.</p>
<hr>
<!-- <b class="function-name">mute</b><code class="function-usage">ac.mute(true/false)</code>
<br>
<p>Set to true to echo all logs to console and to false to silence console messages.</p>
<hr> -->
<b class="function-name">registerActivityLogger</b><code class="function-usage">ac.registerActivityLogger(url, componentName, componentVersion)</code>
<br>
<p>registerActivityLogger accepts the <b>url</b> to which to send logs, a <b>componentName</b> used to name this tool, and a <b>componentVersion</b> to differentiate between varying version of the tools.  Registration uses these inputs to set up the logging message body that includes items such as <code>componentName</code>, <code>componentVersion</code>, <code>client</code>, and <code>sessionID</code>.  <code>sessionID</code> and <code>client</code> may be passed into via query parameters appended to the URL of the tool.  This allows a lot of flexibility to create tools with many tabs that are all logging to the same session for example.</p>
{% highlight javascript %}
ac.registerActivityLogger(
  "http://xd-draper.xdata.data-tactics-corp.com:1337",
  "my-component",
  "v0.1"
  );
{% endhighlight %}
<hr>
<b class="function-name">logUserActivity</b><code class="function-usage">ac.logUserActivity(activityDescription, activityCode, activityWorkflowState, [metaInformation])</code>
<br>
<p>A user action message attempts to describe the activity the User was meaning to perform.  This activity is described at 3 levels of specificity:
  <ul>
    <li><b>activityDescription:</b> this a natural language description of the activity being performed and provides the most specific description of what the user was doing.</li>
    <li><b>activityCode:</b> this is a coded description of the activity and attempts to summarize the action into a 1-4 word code that can ideally be generalized across various tools.</li>
    <li><b>activityWorkflowState:</b> this is the least specific description of the activity and is used to provided meaningful correlations across various tools.
    </li>
  </ul>
</p>

<p>
  The <b>activityWorkflowState</b> is an integer enumerated by the activityLogger, and can be one of 7 of the possible options (follow the links for more information):
  <ul class="wfCodes">
    <li class="badge wf_define light"><a href="define.html">ac.WF_DEFINE</a></li>
    <li class="badge wf_getdata light"><a href="getdata.html">ac.WF_GETDATA</a></li>
    <li class="badge wf_explore light"><a href="explore.html">ac.WF_EXPLORE</a></li>
    <li class="badge wf_create light"><a href="create.html">ac.WF_CREATE</a></li>
    <li class="badge wf_enrich light"><a href="enrich.html">ac.WF_ENRICH</a></li>
    <li class="badge wf_transform light"><a href="transform.html">ac.WF_TRANSFORM</a></li>
    <li class="badge wf_other light"><a href="other.html">ac.WF_OTHER</a></li>
  </ul>
</p>
{% highlight javascript %}
$('#button').mouseenter(function() {
  ac.logUserActivity(
  'User hovered over element to read popup', // description
  'hover_start', // activity_code
  ac.WF_EXPLORE // workflow State
  );
})
{% endhighlight %}
<hr>
<b class="function-name">logSystemActivity</b><code class="function-usage">ac.logSystemActivity(activityDescription, [metaInformation])</code>
<br>
<p>logSystemActivity accepts a natural language <b>activityDescription</b> of the system activity.  A system action message attempts to describe actions that were being performed by the system, either independently of the user, or as a cascading effect of past user actions. The system action message only requires a description, but may need more structure in future implementations.</p>

{% highlight javascript %}
ac.logSystemActivity('asking server for data.');

$.getJSON('https://my_endpoint/get_data', data, function(data) {
  ac.logSystemActivity('received data from server.');
  $("#result").text(data.result);
});
{% endhighlight %}