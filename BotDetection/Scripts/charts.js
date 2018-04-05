function drawScatterChart(data) {

    //drawing the scatter graph (issues with the Y axis numbering)
    //setting margins
    var margin = { top: 20, right: 15, bottom: 60, left: 60 }
        , width = 500 - margin.top - margin.bottom
        , height = 500 - margin.top - margin.bottom;

    //
    var x = d3.scale.linear()
        .domain([-1, 1])
        .range([0, width]);

    var y = d3.scale.linear()
        .domain([-1, 1])
        .range([height, 0]);

    var chart = d3.select('.scatterChart')
        .append('svg:svg')
        .attr('width', width + margin.right + margin.left)
        .attr('height', height + margin.top + margin.bottom)
        .attr('class', 'chart')

    var main = chart.append('g')
        .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
        .attr('width', width)
        .attr('height', height)
        .attr('class', 'main')

    // draw the x axis
    var xAxis = d3.svg.axis()
        .scale(x)
        .orient('bottom');

    main.append('g')
        .attr('transform', 'translate(0,' + height + ')')
        .attr('class', 'main axis date')
        .call(xAxis);

    // draw the y axis
    var yAxis = d3.svg.axis()
        .scale(y)
        .orient('left');

    main.append('g')
        .attr('transform', 'translate(0,0)')
        .attr('class', 'main axis date')
        .call(yAxis);

    var g = main.append("svg:g");

    g.selectAll("scatter-dots")
        .data(data)
        .enter().append("svg:circle")
        .attr("cx", function (d, i) { return x(d[0]); })
        .attr("cy", function (d) { return y(d[1]); })
        .attr("r", 2);

    chart.selectAll(".tick")
        .each(function (d, i) {
            if (d != 1) {
                this.remove();
            }

        });
    chart.selectAll("text")
        .each(function (d, i) {
            if (d != 1 && d != -1) {
                this.remove();
            }

        });
}

function drawHeatmapChart(data, className) {

    //using http://bl.ocks.org/tjdecke/5558084

    d3.select(className).selectAll("svg")
        .each(function (d, i) {
            this.remove();

        });

    var margin = { top: 50, right: 0, bottom: 100, left: 30 },
        width = $(".heatMap").outerWidth() / 1.8 - margin.left - margin.right,
        height = $(".heatMap").outerHeight() / 2 - margin.top - margin.bottom,
        gridSize = Math.floor(width / 24),
        legendElementWidth = gridSize / 2,
        buckets = 9,
        colors = ["#ffffd9", "#edf8b1", "#c7e9b4", "#7fcdbb", "#41b6c4", "#1d91c0", "#225ea8", "#253494", "#081d58"], // alternatively colorbrewer.YlGnBu[9]
        days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"],
        times = ["1a", "2a", "3a", "4a", "5a", "6a", "7a", "8a", "9a", "10a", "11a", "12a", "1p", "2p", "3p", "4p", "5p", "6p", "7p", "8p", "9p", "10p", "11p", "12p"];


    var svg = d3.select(className).append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var dayLabels = svg.selectAll(".dayLabel")
        .data(days)
        .enter().append("text")
        .text(function (d) { return d; })
        .attr("x", 0)
        .attr("y", function (d, i) { return i * gridSize; })
        .style("text-anchor", "end")
        .attr("transform", "translate(-6," + gridSize / 1.5 + ")")
        .attr("class", function (d, i) { return ((i >= 0 && i <= 4) ? "dayLabel mono axis axis-workweek" : "dayLabel mono axis"); });

    var timeLabels = svg.selectAll(".timeLabel")
        .data(times)
        .enter().append("text")
        .text(function (d) { return d; })
        .attr("x", function (d, i) { return i * gridSize; })
        .attr("y", 0)
        .style("text-anchor", "middle")
        .attr("transform", "translate(" + gridSize / 2 + ", -6)")
        .attr("class", function (d, i) { return ((i >= 7 && i <= 16) ? "timeLabel mono axis axis-worktime" : "timeLabel mono axis"); });

    var heatmapChart = function (data) {

        var colorScale = d3.scale.quantile()
            .domain([0, buckets - 1, d3.max(data, function (d) { return d.value; })])
            .range(colors);

        var cards = svg.selectAll(".hour")
            .data(data, function (d) { return d.day + ':' + d.hour; });

        cards.append("title");

        cards.enter().append("rect")
            .attr("x", function (d) { return (d.hour - 1) * gridSize; })
            .attr("y", function (d) { return (d.day - 1) * gridSize; })
            .attr("rx", 4)
            .attr("ry", 4)
            .attr("class", "hour bordered")
            .attr("width", gridSize)
            .attr("height", gridSize)
            .style("fill", colors[0]);

        cards.transition().duration(1000)
            .style("fill", function (d) { return colorScale(d.value); });

        cards.select("title").text(function (d) { return d.value; });

        cards.exit().remove();

        var legend = svg.selectAll(".legend")
            .data([0].concat(colorScale.quantiles()), function (d) { return d; });

        legend.enter().append("g")
            .attr("class", "legend");

        legend.append("rect")
            .attr("x", function (d, i) { return legendElementWidth * i; })
            .attr("y", gridSize * 7.3)
            .attr("width", legendElementWidth)
            .attr("height", gridSize / 2)
            .style("fill", function (d, i) { return colors[i]; });

        legend.append("text")
            .attr("class", "mono")
            .text("Low to High")
            .attr("x", legendElementWidth)
            .attr("y", gridSize * 8);


        legend.exit().remove();

    };

    heatmapChart(data);
    d3.select(".heatMap").style("display", "block");
}

function drawSentimentChart(data, className) {
    d3.select(className).selectAll("svg")
        .each(function (d, i) {
            this.remove();

        });

    var margin = { top: 20, right: 30, bottom: 40, left: 30 },
        width = $(window).innerWidth() / 3 - margin.left - margin.right,
        height = $(window).innerHeight() / 1.5 - margin.top - margin.bottom;

    var x = d3.scale.linear()
        .range([0, width]);

    var y = d3.scale.ordinal()
        .rangeRoundBands([0, height], 0.1);

    var xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom");

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient("left")
        .tickSize(0)
        .tickPadding(6);

    var svg = d3.select(className).append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    x.domain(d3.extent(data, function (d) { return d.value; })).nice();
    y.domain(data.map(function (d) { return d.name; }));

    svg.selectAll(".bar")
        .data(data)
        .enter().append("rect")
        .attr("class", function (d) { return "bar bar--" + (d.value < 0 ? "negative" : "positive"); })
        .attr("x", function (d) { return x(Math.min(0, d.value)); })
        .attr("y", function (d) { return y(d.name); })
        .attr("width", function (d) { return Math.abs(x(d.value) - x(0)); })
        .attr("height", y.rangeBand());

    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

    svg.append("g")
        .attr("class", "y axis")
        .attr("transform", "translate(" + x(0) + ",0)")
        .call(yAxis);

    svg.select(".y").selectAll("text")
        .each(function (d, i) {
            this.remove();

        });

    d3.select(".sentimentChart").style("display", "block");
}

function drawPieChart(dataset, className) {

    d3.select(className).selectAll("svg")
        .each(function (d, i) {
            this.remove();

        });

    var width = $(".pieChart").outerWidth() / 3;
    var height = $(".pieChart").outerWidth() / 3;
    var radius = Math.min(width, height) / 2;
    var donutWidth = radius/10;
    var color = d3.scale.category10();
    var legendRectSize = 18;
    var legendSpacing = 4;

    var svg = d3.select(className)
        .append('svg')
        .attr('width', width)
        .attr('height', height)
        .append('g')
        .attr('transform', 'translate(' + (width / 2) +
        ',' + (height / 2) + ')');

    var arc = d3.svg.arc()
        .innerRadius(radius - donutWidth)
        .outerRadius(radius);

    var pie = d3.layout.pie()
        .value(function (d) { return d.count; })
        .sort(null);

    var path = svg.selectAll('path')
        .data(pie(dataset))
        .enter()
        .append('path')
        .attr('d', arc)
        .attr('fill', function (d, i) {
            return color(d.data.label);
        });

    var legend = svg.selectAll('.legend')
        .data(color.domain())
        .enter()
        .append('g')
        .attr('class', 'legend')
        .attr('transform', function (d, i) {
            var height = legendRectSize + legendSpacing;
            var offset = height * color.domain().length / 2;
            var horz = -2 * legendRectSize;
            var vert = i * height - offset;
            return 'translate(' + horz + ',' + vert + ')';
        });

    legend.append('rect')
        .attr('width', legendRectSize)
        .attr('height', legendRectSize)
        .style('fill', color)
        .style('stroke', color);
    legend.append('text')
        .attr('x', legendRectSize + legendSpacing)
        .attr('y', legendRectSize - legendSpacing)
        .text(function (d) { return d; });

    d3.select(".pieChart").style("display", "block");

}

function drawBarChart(data, className) {

    d3.select(className).selectAll("svg")
        .each(function (d, i) {
            this.remove();

        });
    console.log(data);

    var margin = { top: 40, right: 20, bottom: 30, left: 40 },
        width = $(window).innerWidth() / 3 - margin.left - margin.right,
        height = $(window).innerHeight() / 2 - margin.top - margin.bottom;


    var x = d3.scale.ordinal()
        .rangeRoundBands([0, width], .1);

    var y = d3.scale.linear()
        .range([height, 0]);

    var xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom");

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient("left");

    var svg = d3.select(className).append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


    // The following code was contained in the callback function.
    x.domain(data.map(function (d) { return d.letter; }));
    y.domain([0, d3.max(data, function (d) { return d.frequency; })]);

    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
        .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Frequency");

    svg.selectAll(".bar")
        .data(data)
        .enter().append("rect")
        .attr("class", "bar")
        .attr("x", function (d) { return x(d.letter); })
        .attr("width", x.rangeBand())
        .attr("y", function (d) { return y(d.frequency); })
        .attr("height", function (d) { return height - y(d.frequency); })

    d3.select(".barChart").style("display", "block");
}
