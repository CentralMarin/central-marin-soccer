window.namespace = function (ns) {
        var i, parent = window, elems = ns.split(".");

        for (i = 0; i < elems.length; i++) {
                if (!parent[elems[i]]) {
                        parent[elems[i]] = {};
                }

                parent = parent[elems[i]];
        }
};