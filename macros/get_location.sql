{% macro get_location(location_code_column) %}

{% set locations = {
    1: 'top left',
    2: 'top middle',
    3: 'top right',
    4: 'bottom left',
    5: 'bottom middle',
    6: 'bottom right'
} %}

case {{ location_code_column }}
    {% for code, name in locations.items() %}
    when {{ code }} then '{{ name }}'
    {% endfor %}
    else 'unknown'
end

{% endmacro %}