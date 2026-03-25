{% macro get_color(color_code_column) %}

{% set colors = {
    1: 'beige',
    2: 'black',
    3: 'blue',
    4: 'brown',
    5: 'burgundy',
    6: 'gray',
    7: 'green',
    8: 'navy blue',
    9: 'multicolor',
    10: 'olive',
    11: 'pink',
    12: 'red',
    13: 'violet',
    14: 'white'
} %}

case {{ color_code_column }}
    {% for code, name in colors.items() %}
    when {{ code }} then '{{ name }}'
    {% endfor %}
    else 'unknown'
end

{% endmacro %}