# XSLT Kit

This template collection combines XSLT utilities we regularly use in our projects. Some templates require a specific XML structure provided by our [Kirby XSLT plugin](https://github.com/hananils/kirby-xslt). If you are working with Symphony CMS, have a look at the [dedicated branch](https://github.com/hananils/xslt-kit/tree/symphony).

## Namespace

All templates are namespaced, please add the following to your stylesheet:

```xslt
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:kit="https://hananils.de/xslt/kit">
```

## Requirements

The kit requires the EXSLT extension, <http://exslt.org/>.
