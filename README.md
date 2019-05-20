# XSLT Kit

This template kit combines XSLT utilities we regularly use in our projects. Some templates require a specific XML structure provided by our [Kirby XSLT plugin](https://github.com/hananils/kirby-xslt). If you are working with Symphony CMS, have a look at the [dedicated branch](https://github.com/hananils/xslt-kit/tree/symphony).

## Requirements

The kit requires the EXSLT extension, <http://exslt.org/>.

## Namespace

All templates are namespaced, please add the following to your stylesheet:

```xslt
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:kit="https://hananils.de/xslt/kit">
```

## Included templates and modes

All templates can be applied using `<xsl:apply-templates />` using the matching mode:

- `kit:transform`: If you apply this mode to a HTML structure, nothing changes in the output by default. But this mode allows you to offset the headline hierarchy, e. g. changing a `h1` to a `h3`, or to match templates to elements allowing custom transforms. This is very helpful when you are dealing with HTML sources generated using Markdown. For more information see http://www.getsymphony.com/learn/articles/view/html-ninja-technique/.
- `kit:dates`: Formats Kirby XSLT date nodes to a human readable date.
- `kit:dates-time`: Formats Kirby XSLT date nodes to a human readabel time.
- `kit:dates-range`: Creates human readable date and time ranges from a Kirby XSLT date node.
- `kit:dates-years`: Creates human readable year ranges from a node set containing year values.
- `kit:list`: Converts node sets to list, e. g. using a comma separator.
- `kit:links`: Creates human friendly links.
- `kit:email`: Creates a HTML link from a textual e-mail node.
- `kit:name`: Formats a name with title, prefix and suffix.

There is also a language template containing information about the current Kirby content language as well as translation strings.
