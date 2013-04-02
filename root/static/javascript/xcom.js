var soldiers = [];
var countries = []
var ranks = [];
var classes = [];

var SOLDIERS = {
    table:              null,
    ID_COL_IDX:         0,
    NAME_COL_IDX:       1,
    DEAD_COL_IDX:       2,
    CLASS_ID_COL_IDX:   3,
    CLASS_COL_IDX:      4,
    RANK_ID_COL_IDX:    5,
    RANK_COL_IDX:       6,
    COUNTRY_ID_COL_IDX: 7,
    COUNTRY_COL_IDX:    8,
    AIM_COL_IDX:        9,
    WILL_COL_IDX:       10,
    HP_COL_IDX:         11,
    PSIONIC_COL_IDX:    12,
    POINTS_COL_IDX:     13,
    TREND_COL_IDX:      14,
    ACTIONS_COL_IDX:    15
};

SOLDIERS.INVISIBLE  = [ SOLDIERS.CLASS_ID_COL_IDX, SOLDIERS.RANK_ID_COL_IDX, SOLDIERS.COUNTRY_ID_COL_IDX ];
SOLDIERS.UNSORTABLE = [ SOLDIERS.ACTIONS_COL_IDX ];

function xcom_init(properties) {
    countries = properties.countries;
    ranks     = properties.ranks;
    classes   = properties.classes;

    $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
    $(document).ajaxError(function(e, xhr, settings, error) {
        alert('Could not complete request...');
    });

    SOLDIERS.table = $('#soldiers-table').dataTable({
        "bPaginate": false,
        "bFilter": true,
        "bSort": true,
        "aaSorting": [
            [ SOLDIERS.POINTS_COL_IDX, "desc" ],
            [ SOLDIERS.DEAD_COL_IDX, "asc" ]
        ],
        "aoColumnDefs": [
            { "bVisible": false, "aTargets": SOLDIERS.INVISIBLE },
            { "bSortable": false, "aTargets": SOLDIERS.UNSORTABLE }
        ]
    });

    $.each(properties.soldiers, function(index, soldier) {
        add_soldier(soldier, false);
    });

    update_best();
    update_upandcoming();
    update_class_best();

    $('#soldier-add-dialog select[name=country_id]').change(function() {
        update_country($(this));
    });

    $('#soldier-add-dialog input[name=aim]').spinner();
    $('#soldier-add-dialog input[name=will]').spinner();
    $('#soldier-add-dialog input[name=hp]').spinner();

    $('#add-soldier').click(function() {
        setup_soldier_form();

        $('#soldier-add-dialog').dialog({
            title: 'Add Soldier',
            modal: true,
            width: 400,
            height: 525,
            buttons: {
                Save: function() {
                    save_soldier();
                    $(this).dialog("close");
                },
                Cancel: function() {
                    $(this).dialog("close");
                }
            },
            close: function() {
                clear_soldier_form();
            }
        });
    });
}

/*
    Table Columns
    ID
    Name
    Is Dead
    Class ID
    Class
    Rank ID
    Rank
    Country ID
    Country
    Aim
    Will
    HP
    Points
*/

function save_soldier(id, row) {
    var data = {
        first_name: $('#soldier-add-dialog input[name=first_name]').val(),
        last_name:  $('#soldier-add-dialog input[name=last_name]').val(),
        nick_name:  $('#soldier-add-dialog input[name=nick_name]').val(),
        class_id:   $('#soldier-add-dialog select[name=class_id]').val() == 0 ? null : $('#soldier-add-dialog select[name=class_id]').val(),
        rank_id:    $('#soldier-add-dialog select[name=rank_id]').val(),
        country_id: $('#soldier-add-dialog select[name=country_id]').val(),
        aim:        $('#soldier-add-dialog input[name=aim]').val(),
        will:       $('#soldier-add-dialog input[name=will]').val(),
        hp:         $('#soldier-add-dialog input[name=hp]').val(),
        psionic:    $('#soldier-add-dialog input[name=psionic]:checked').is('*') ? 1 : 0,
        dead:       $('#soldier-add-dialog input[name=dead]:checked').is('*') ? 1 : 0
    };

    var url = 'soldiers';
    if (id) url += '/' + id;

    $.ajax({
        url: url,
        dataType: 'json',
        contentType: 'application/json; charset=UTF-8',
        data: JSON.stringify(data),
        type: 'POST',
        success: function(data) {
            if (id) {
                remove_soldier(id, row);
                add_soldier(data.soldier, true);
            }
            else {
                add_soldier(data.soldier, true);
            }
        },
    });
}

function add_soldier(soldier, update) {
    soldiers.push(soldier);

    SOLDIERS.table.fnAddData([
        soldier.id,
        format_soldier_name(soldier.first_name, soldier.last_name, soldier.nick_name),
        soldier.dead == 1 ? 'Yes' : 'No',
        soldier['class'] ? soldier['class'].id : 0,
        soldier['class'] ? soldier['class'].name : 'None',
        soldier.rank ? soldier.rank.id : 0,
        soldier.rank ? soldier.rank.name : 'None',
        soldier.country_id,
        format_soldier_country(soldier.country),
        soldier.aim,
        soldier.will,
        soldier.hp,
        soldier.psionic == 1 ? 'Yes' : 'No',
        format_soldier_points(soldier.aim, soldier.will, soldier.hp, soldier.psionic),
        format_soldier_trend(soldier),
        format_soldier_actions(soldier.id),
    ]);

/*
    Table Columns
    ID
    Name
    Is Dead
    Class ID
    Class
    Rank ID
    Rank
    Country ID
    Country
    Aim
    Will
    HP
    Points
*/
    $('#edit-' + soldier.id).click(function() {
        var id = parseFloat($(this).attr('id').replace('edit-', ''));
        var tr = $(this).parent().parent();

        setup_soldier_form();

        $.ajax({
            url: 'soldiers/' + id,
            dataType: 'json',
            contentType: 'application/json; charset=UTF-8',
            type: 'GET',
            success: function(data) {
                var soldier = data.soldier;

                $('#soldier-add-dialog input[name=first_name]').val(soldier.first_name);
                $('#soldier-add-dialog input[name=last_name]').val(soldier.last_name);
                $('#soldier-add-dialog input[name=nick_name]').val(soldier.nick_name);
                $('#soldier-add-dialog select[name=class_id]').val(soldier.class_id);
                $('#soldier-add-dialog select[name=rank_id]').val(soldier.rank_id);
                $('#soldier-add-dialog select[name=country_id]').val(soldier.country_id);
                $('#soldier-add-dialog input[name=aim]').val(soldier.aim);
                $('#soldier-add-dialog input[name=will]').val(soldier.will);
                $('#soldier-add-dialog input[name=hp]').val(soldier.hp);
                $('#soldier-add-dialog input[name=psionic]').prop('checked', soldier.psionic == 1);
                $('#soldier-add-dialog input[name=dead]:checked').prop('checked', soldier.dead == 1);

                $('#soldier-add-dialog').dialog({
                    title: 'Edit Soldier',
                    modal: true,
                    width: 400,
                    height: 525,
                    buttons: {
                        Save: function() {
                            save_soldier(id, tr[0]);
                            $(this).dialog("close");
                        },
                        Cancel: function() {
                            $(this).dialog("close");
                        }
                    },
                    close: function() {
                        clear_soldier_form();
                    }
                });
            },
        });
    });

    $('#delete-' + soldier.id).click(function() {
        var id = parseFloat($(this).attr('id').replace('delete-', ''));
        var tr = $(this).parent().parent();

        $.ajax({
            url: 'soldiers/' + id,
            dataType: 'json',
            contentType: 'application/json; charset=UTF-8',
            type: 'DELETE',
            success: function() {
                remove_soldier(id, tr);
            },
        });
    });

    $('#graph-' + soldier.id).click(function() {
        var id = parseFloat($(this).attr('id').replace('delete-', ''));
        var tr = $(this).parent().parent();

        $('#graph').html('');
        $('#graph').append('<div id="improvements"></div>');
        $('#graph').append('<div id="aim_chart"></div>');
        $('#graph').append('<div id="will_chart"></div>');
        $('#graph').append('<div id="hp_chart"></div>');

        $('#graph').dialog({
            title: 'Soldier History',
            width: 600,
            height: 450,
            modal: true,
            buttons: {
                Cancel: function() {
                    $(this).dialog('close');
                }
            },
            open: function() {

                if (soldier.soldier_histories.length > 1) {
                    var prev_history = soldier.soldier_histories[0];
                    
                    var aim_diff  = soldier.aim - prev_history.aim;
                    var will_diff = soldier.will - prev_history.will;
                    var hp_diff   = soldier.hp - prev_history.hp;

                    $('#improvements').append(
                        $('<h3>').append('Trend')
                    ).append(
                        $('<p>').append('Aim: ' + aim_diff)
                    ).append(
                        $('<p>').append('Will: ' + will_diff)
                    ).append(
                        $('<p>').append('HP: ' + hp_diff)
                    );

                    var aim_array = [];
                    var will_array = [];
                    var hp_array = [];            

                    for (var i = 0; i < soldier.soldier_histories.length; i++) {
                        var history = soldier.soldier_histories[i];

                        if (history) {
                            aim_array.push(parseFloat(history.aim));
                            will_array.push(parseFloat(history.will));
                            hp_array.push(parseFloat(history.hp));
                        }
                    }

                    $.jqplot('aim_chart', [ aim_array ], {
                        axes: {
                            yaxis: {
                                label: 'Aim',
                                min: aim_array[0] - 10,
                                max: aim_array[aim_array.length - 1] + 10
                            }
                        }
                    });

                    $.jqplot('will_chart', [ will_array ], {
                        axes: {
                            yaxis: {
                                label: 'Will',
                                min: will_array[0] - 10,
                                max: will_array[will_array.length - 1] + 10
                            }
                        }
                    });

                    $.jqplot('hp_chart', [ hp_array ], {
                        axes: {
                            yaxis: {
                                label: 'HP',
                                min: hp_array[0] - 2,
                                max: hp_array[hp_array.length - 1] + 2
                            }
                        }
                    });

                }
                else {
                    $('#improvements').html('Not enough data.');
                }
            }
        });
    });

    if (update) {
        update_best();
        update_upandcoming();
        update_class_best();
    }
}

function setup_soldier_form() {
    $('#soldier-add-dialog select[name=class_id] option').remove();
    $('#soldier-add-dialog select[name=rank_id] option').remove();

    $('#soldier-add-dialog select[name=class_id]').append('<option value="0">None</option>');
    $.each(classes, function(index, class_obj) {
        $('#soldier-add-dialog select[name=class_id]').append('<option value="' + class_obj.id + '">' + class_obj.name + '</option>');
    });

    $.each(ranks, function(index, rank) {
        $('#soldier-add-dialog select[name=rank_id]').append('<option value="' + rank.id + '">' + rank.name + '</option>');
    });

    $.each(countries, function(index, country) {
        $('#soldier-add-dialog select[name=country_id]').append('<option value="' + country.id + '">' + country.short_name + '</option>');
    });

    update_country($('#soldier-add-dialog select[name=country_id]'));
}

function clear_soldier_form() {
    $('#soldier-add-dialog input[type=text]').val('');
    $('#soldier-add-dialog input[name=aim]').val(0);
    $('#soldier-add-dialog input[name=will]').val(0);
    $('#soldier-add-dialog input[name=hp]').val(0);
}

function format_soldier_name(first, last, nick_name) {
    return nick_name ? first + ' "' + nick_name + '" ' + last : first + ' ' + last;
}

function soldier_name(soldier) {
    return soldier.nick_name ? soldier.first_name + ' "' + soldier.nick_name + '" ' + soldier.last_name : soldier.first_name + ' ' + soldier.last_name;
}

function format_soldier_country(country) {
    return '<img src="/static/images/flags/' + country.iso2 + '.png" class="flag" /> ' + country.short_name;
}

function format_soldier_points(aim, will, hp, psionic) {
    aim  = parseFloat(aim);
    will = parseFloat(will);
    hp   = parseFloat(hp);
    psionic = parseFloat(psionic);

    return aim + will + hp + (psionic * 10);
}

function soldier_points(soldier) {
    aim  = parseFloat(soldier.aim);
    will = parseFloat(soldier.will);
    hp   = parseFloat(soldier.hp);
    psionic = parseFloat(soldier.psionic);

    return aim + will + hp + (psionic * 10);
}

function format_soldier_trend(soldier) {
    var histories = soldier.soldier_histories;

    if (histories.length > 1) {
        var prev_history = soldier.soldier_histories[0];
                    
        var aim_diff  = soldier.aim - prev_history.aim;
        var will_diff = soldier.will - prev_history.will;
        var hp_diff   = soldier.hp - prev_history.hp;

        if (aim_diff == 0 && will_diff == 0 && hp_diff == 0) {
            return '<span style="display:none;">0</span><img src="/static/images/minimize.png" />';
        }
        else {
            var trend_value = (aim_diff > 2 || will_diff > 2) ? 'arrow_top' : 'arrow_down';        
            return '<span style="display:none;">' + Math.max(aim_diff, will_diff) + '</span><img src="/static/images/' + trend_value + '.png" />';
        }
    }
    else {
        return '<span style="display:none;">0</span><img src="/static/images/minimize.png" />';
    }
}

function format_soldier_actions(id) {
    return '<img src="/static/images/comments.png" class="action graph" id="graph-' + id + '" /><img src="/static/images/reply.png" class="action edit" id="edit-' + id + '" /><img src="/static/images/action_delete.png" class="action delete" id="delete-' + id + '" />';
}

function remove_soldier(id, tr) {
    var remove = null;

    for (var index in soldiers) {
        if (soldiers[index].id == id) {
            remove = index;
            break;
        }
    }

    if (remove) {
        soldiers.splice(remove, 1);
    }
    
    // Data Tables bug -- removing last row makes it herp the maximum derp
    if (soldiers.length == 0) {
        SOLDIERS.table.fnClearTable();
    }
    else {
        SOLDIERS.table.fnDeleteRow(tr);
    }

    update_best();
    update_upandcoming();
    update_class_best();
}

function update_country(that) {
    var country = null;

    for (var i in countries) {
        if (countries[i].id == that.val()) {
            country = countries[i];
            break;
        }
    }

    var img = $('#soldier-add-dialog img.flag');

    if (country) {
        img.attr('src', '/static/images/flags/' + country.iso2 + '.png');
        img.show();            
    }
    else {
        img.hide();
    }
}

function update_best() {
    var best = {};

    $.each(soldiers, function(index, soldier) {
        if (soldier['class'] && soldier.dead == 0) {
            if (!best[soldier['class'].name]) {
                best[soldier['class'].name] = soldier;
            }

            if (soldier_points(best[soldier['class'].name]) < soldier_points(soldier)) {
                best[soldier['class'].name] = soldier;
            }
        }
    });

    $('#best-of div').html('');
    for (var class_name in best) {
        $('#best-of div').append(
            $('<p>').append(
                $('<img>').attr('src', '/static/images/classes/' + class_name + '.png').addClass('class_icon')
            ).append(
                soldier_name(best[class_name])
            ).append(
                ' (' + soldier_points(best[class_name]) + ')'
            )
        );
    }
}

function update_upandcoming() {
    var up_and_coming = [];

    $.each(soldiers, function(index, soldier) {
        if (!soldier['class'] && soldier.dead == 0) up_and_coming.push(soldier);
    });

    up_and_coming = up_and_coming.sort(function(a, b) {
        return soldier_points(b) - soldier_points(a);
    });

    $('#up-and-coming div').html('');
    for (var i = 0; i < Math.min(up_and_coming.length, 5); i++) {
        $('#up-and-coming div').append(
            $('<p>').attr('id', 'up-and-coming-' + up_and_coming[i].id)
            .append(
                $('<img>').attr('src', '/static/images/flags/' + up_and_coming[i].country.iso2 + '.png').addClass('flag')
            ).append(
                soldier_name(up_and_coming[i])
            ).append(
                ' (' + soldier_points(up_and_coming[i]) + ')'
            ).click(function() {
                var id = $(this).attr('id').replace('up-and-coming-', '');
                $('#edit-' + id).click();
            })
        );
    }
}

function update_class_best() {
    var best_of = {};

    $.each(classes, function(index, class_obj) {
        best_of[class_obj.name] = [];
    });

    $.each(soldiers, function(index, soldier) {
        if (soldier['class'] && best_of[soldier['class'].name]) {
            best_of[soldier['class'].name].push(soldier);
        }
    });

    $.each(classes, function(index, class_obj) {
        best_of[class_obj.name] = best_of[class_obj.name].sort(function(a, b) {
            return soldier_points(b) - soldier_points(a);
        });

        $('#' + class_obj.name.toLowerCase() + '-best div').html('');
        for (var i = 0; i < Math.min(best_of[class_obj.name].length, 5); i++) {
            $('#' + class_obj.name.toLowerCase() + '-best div').append(
                $('<p>').append(
                    soldier_name(best_of[class_obj.name][i])
                ).append(
                   ' (' + soldier_points(best_of[class_obj.name][i]) + ')'
                )
            );
        }
    });
}

// Array Remove - By John Resig (MIT Licensed)
Array.prototype.remove = function(from, to) {
  var rest = this.slice((to || from) + 1 || this.length);
  this.length = from < 0 ? this.length + from : from;
  return this.push.apply(this, rest);
};
