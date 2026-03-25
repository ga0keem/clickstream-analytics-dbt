{% macro get_category(category_code_column) %}

{% set categories = {
    1: 'trousers',
    2: 'skirts',
    3: 'blouses',
    4: 'sale'
} %}

case {{ category_code_column }}
    {% for code, name in categories.items() %}
    when {{ code }} then '{{ name }}'
    {% endfor %}
    else 'unknown'
end

{% endmacro %}