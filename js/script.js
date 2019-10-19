var apexFlipCards = (function () {
    "use strict";
    var scriptVersion = "1.0.3";
    var util = {
        version: "1.0.5",
        isAPEX: function () {
            if (typeof (apex) !== 'undefined') {
                return true;
            } else {
                return false;
            }
        },
        debug: {
            info: function (str) {
                if (util.isAPEX()) {
                    apex.debug.info(str);
                }
            },
            error: function (str) {
                if (util.isAPEX()) {
                    apex.debug.error(str);
                } else {
                    console.error(str);
                }
            }
        },
        loader: {
            start: function (id) {
                if (util.isAPEX()) {
                    apex.util.showSpinner($(id));
                } else {
                    /* define loader */
                    var faLoader = $("<span></span>");
                    faLoader.attr("id", "loader" + id);
                    faLoader.addClass("ct-loader");

                    /* define refresh icon with animation */
                    var faRefresh = $("<i></i>");
                    faRefresh.addClass("fa fa-refresh fa-2x fa-anim-spin");
                    faRefresh.css("background", "rgba(121,121,121,0.6)");
                    faRefresh.css("border-radius", "100%");
                    faRefresh.css("padding", "15px");
                    faRefresh.css("color", "white");

                    /* append loader */
                    faLoader.append(faRefresh);
                    $(id).append(faLoader);
                }
            },
            stop: function (id) {
                $(id + " > .u-Processing").remove();
                $(id + " > .ct-loader").remove();
            }
        },
        jsonSaveExtend: function (srcConfig, targetConfig) {
            var finalConfig = {};
            /* try to parse config json when string or just set */
            if (typeof targetConfig === 'string') {
                try {
                    targetConfig = JSON.parse(targetConfig);
                } catch (e) {
                    console.error("Error while try to parse targetConfig. Please check your Config JSON. Standard Config will be used.");
                    console.error(e);
                    console.error(targetConfig);
                }
            } else {
                finalConfig = targetConfig;
            }
            /* try to merge with standard if any attribute is missing */
            try {
                finalConfig = $.extend(true, srcConfig, targetConfig);
            } catch (e) {
                console.error('Error while try to merge 2 JSONs into standard JSON if any attribute is missing. Please check your Config JSON. Standard Config will be used.');
                console.error(e);
                finalConfig = srcConfig;
                console.error(finalConfig);
            }
            return finalConfig;
        },
        noDataMessage: {
            show: function (id, text) {
                var div = $("<div></div>")
                    .css("margin", "12px")
                    .css("text-align", "center")
                    .css("padding", "64px 0")
                    .addClass("nodatafoundmessage");

                var subDiv = $("<div></div>");

                var subDivSpan = $("<span></span>")
                    .addClass("fa")
                    .addClass("fa-search")
                    .addClass("fa-2x")
                    .css("height", "32px")
                    .css("width", "32px")
                    .css("color", "#D0D0D0")
                    .css("margin-bottom", "16px");

                subDiv.append(subDivSpan);

                var span = $("<span></span>")
                    .text(text)
                    .css("display", "block")
                    .css("color", "#707070")
                    .css("font-size", "12px");

                div
                    .append(subDiv)
                    .append(span);

                $(id).append(div);
            },
            hide: function (id) {
                $(id).children('.nodatafoundmessage').remove();
            }
        }
    };

    /***********************************************************************
     **
     ** Used to draw a container
     **
     ***********************************************************************/
    function drawContainer(parent) {
        var div = $("<div></div>");
        div.addClass("flip-c-container");
        parent.append(div);
        return (div);
    }

    /***********************************************************************
     **
     ** Used to draw a row
     **
     ***********************************************************************/
    function drawRow(parent) {
        var div = $("<div></div>");
        div.addClass("flip-c-row");
        parent.append(div);
        return (div);
    }
    /************************************************************************
     **
     ** Used to render the html into region
     **
     ***********************************************************************/
    function renderHTML(pParentID, pData, pEscapeHTML, pConfigJSON) {

        var parent = $(pParentID);
        parent.parent().css("overflow", "inherit");

        var container = drawContainer(parent);
        var row = drawRow(container);
        var cardNum = 0;
        var zindex = 10;

        $.each(pData, function (idx, data) {
            cardNum = cardNum + pConfigJSON.cardWidth;

            var matFlipCardCol = $("<div></div>");
            matFlipCardCol.addClass("flip-c-col-" + pConfigJSON.cardWidth);

            var matFlipCard = $("<div></div>");
            matFlipCard.addClass("mat-flip-card");

            var matFlipCardImg = $("<img>");
            matFlipCardImg.addClass("mat-flip-card__image");
            matFlipCardImg.attr("src", data.IMG_SRC);

            matFlipCard.append(matFlipCardImg);

            var matFlipCardTitle = $("<div></div>");
            matFlipCardTitle.addClass("mat-flip-card-title");

            var titleToggle = $("<a></a>");
            titleToggle.addClass("toggle-info");
            titleToggle.addClass("btn");

            var leftSpan = $("<span></span>");
            leftSpan.addClass("left");

            titleToggle.append(leftSpan);

            var rightSpan = $("<span></span>");
            rightSpan.addClass("right");

            titleToggle.append(rightSpan);

            matFlipCardTitle.append(titleToggle);

            var titleText = $("<div></div>");
            titleText.addClass("mat-flip-card-title-text");
            if (pEscapeHTML !== false) {
                titleText.text(data.TITLE);
            } else {
                titleText.html(data.TITLE);
            }

            matFlipCardTitle.append(titleText);

            matFlipCard.append(matFlipCardTitle);

            var matFlipCardFlap = $("<div></div>");
            matFlipCardFlap.addClass("mat-flip-card-flap");
            matFlipCardFlap.addClass("flap1");
            if (data.DESC_BACK_COLOR && data.DESC_BACK_COLOR.length > 0) {
                matFlipCardFlap.css("background", data.DESC_BACK_COLOR);
            }
            if (data.DESC_FONT_COLOR && data.DESC_FONT_COLOR.length > 0) {
                matFlipCardFlap.css("color", data.DESC_FONT_COLOR);
            }

            var matFlipCardDescription = $("<div></div>");
            matFlipCardDescription.addClass("mat-flip-card-description");

            if (pEscapeHTML !== false) {
                matFlipCardDescription.text(data.DESCRIPTION);
            } else {
                matFlipCardDescription.html(data.DESCRIPTION);
            }

            matFlipCardFlap.append(matFlipCardDescription);

            matFlipCard.append(matFlipCardFlap);

            matFlipCardCol.append(matFlipCard);

            row.append(matFlipCardCol);

            if (cardNum >= 12) {
                row = drawRow(container);
                cardNum = 0;
            }

            /* add card flip */

            matFlipCard.click(function (e) {
                e.preventDefault();
                var isShowing = false;

                if ($(this).hasClass("show")) {
                    isShowing = true
                }

                if (parent.hasClass("showing")) {
                    var showElements = parent.find(".show");
                    showElements.removeClass("show");

                    $.each(showElements, function (i, element) {
                        var curCitle = $(element).find(".mat-flip-card-title");
                        var curImage = $(element).find(".mat-flip-card__image");
                        // $(this).height(Math.floor(curCitle.height() + curImage.height()));
                    });

                    if (isShowing) {
                        parent.removeClass("showing");

                    } else {
                        $(this).css("z-index", zindex);
                        $(this).addClass("show");
                        //   $(this).height(Math.floor(matFlipCardTitle.height() + matFlipCardImg.height() + matFlipCardFlap.height()));
                    }

                    zindex++;

                } else {
                    parent.addClass("showing");
                    $(this).css("z-index", zindex);
                    $(this).addClass("show");
                    // $(this).height(Math.floor(matFlipCardTitle.height() + matFlipCardImg.height() + matFlipCardFlap.height()));

                    zindex++;
                }
            });
        });
    }
    /************************************************************************
     **
     ** Used to check data and to call rendering
     **
     ***********************************************************************/
    function prepareData(pParentID, pData, pNoDataFound, pEscapeHTML, pConfigJSON) {
        /* empty container for new stuff */
        $(pParentID).empty();

        if (pData.row && pData.row.length > 0) {
            renderHTML(pParentID, pData.row, pEscapeHTML, pConfigJSON);
        } else {
            $(pParentID).css("min-height", "");
            util.noDataMessage.show(pParentID, pNoDataFound);
        }
        util.loader.stop(pParentID);
    }

    return {
        render: function (regionID, ajaxID, noDataFoundMessage, items2Submit, escapeRequired, udConfigJSON) {
            var parentID = "#" + regionID + "-p";
            var stdConfigJSON = {
                "cardWidth": 4,
                "refresh": 0
            };

            var configJSON = {};
            configJSON = util.jsonSaveExtend(stdConfigJSON, udConfigJSON);
            /************************************************************************
             **
             ** Used to get data from APEX
             **
             ***********************************************************************/
            function getData() {
                $(parentID).css("min-height", "120px");
                util.loader.start(parentID);

                var submitItems = items2Submit;
                try {
                    apex.server.plugin(
                        ajaxID, {
                            pageItems: submitItems
                        }, {
                            success: function (pData) {
                                prepareData(parentID, pData, noDataFoundMessage, escapeRequired, configJSON)
                            },
                            error: function (d) {
                                console.error(d.responseText);
                            },
                            dataType: "json"
                        });
                } catch (e) {
                    console.error("Error while try to get Data from APEX");
                    console.error(e);
                }

            }

            // load data
            getData();

            /************************************************************************
             **
             ** Used to bind APEx Refresh event (DA's)
             **
             ***********************************************************************/
            try {
                apex.jQuery("#" + regionID).bind("apexrefresh", function () {
                    getData();
                });
            } catch (e) {
                console.error("Error while try to bind APEX refresh event");
                console.error(e);
            }

            /************************************************************************
             **
             ** Used to refresh by a timer
             **
             ***********************************************************************/
            if (configJSON.refresh && configJSON.refresh > 0) {
                setInterval(function () {
                    getData();
                }, configJSON.refresh * 1000);
            }
        }
    }

})();
