<!DOCTYPE HTML>
<html>
<head>
</head>
<body>
<script type="text/javascript">
window.onload = function() {

        var chart = new CanvasJS.Chart("chartContainer", {
                animationEnabled: true,
                title: {
                        text: "FlowFile Queue buildup by Processor Group"
                },
                data: [{
                        type: "pie",
                        startAngle: 240,
                        yValueFormatString: "##0.00\"%\"",
                        indexLabel: "{label} {y}",
                        dataPoints: []
                }]
        });

        var pgflowfiles = JSON.parse('{{!flowfilesQueued}}');
        var pgnames = JSON.parse('{{!pgnames}}');
        var y_val = 0

        for (items in pgflowfiles){
                y_val = (pgflowfiles[items]*100/'{{!total}}')
                if(y_val>1){chart.options.data[0].dataPoints.push({y: y_val,label: items + " " + pgnames[items], click : onClick})}
                }

        chart.render();

        };

function onClick(e){
        var answer = confirm(  " Drill down into stats for Processor Group  :" + e.dataPoint.label + " ?" );
        if (answer == true){
                var req = new XMLHttpRequest();
                req.open('POST', '/pie', true);
                var pgid = e.dataPoint.label.split(" ")[0]
                console.log('dataPOint.label is ' + pgid);
                params = 'pgid=' + pgid;
                req.send(params);
                location.reload()
                }
        else {}
   }


</script>
<div id="chartContainer" style="height: 370px; width: 100%;"></div>
<script src="static/canvasjs.min.js"></script>
</body>
</html>
