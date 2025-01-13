# simple_exif

(en)Japanese ver is [here](https://github.com/MasahideMori-SimpleAppli/simple_exif/blob/main/README_JA.md).  
(ja)この解説の日本語版は[ここ](https://github.com/MasahideMori-SimpleAppli/simple_exif/blob/main/README_JA.md)にあります。

## Overview
This is a package for reading Exif information from JPEG images.
This package has been adapted to work with Flutter Web.

This package implements the required or most frequently used parts of the Exif 2.3 standard.  
Note that this package does not cover additional information from other formats such as PNG,
as they are not part of the Exif standard.  

The current implementation status is as follows.  
IFD rewriting is also under development and may be supported in the future.  

- [x] Read the 0th IFD contents (TIFF)
- [x] Read the 0th IFD contents (Exif)
- [x] Read the 0th IFD contents (Interoperability)
- [x] Read the 0th IFD contents (GPS)
- [ ] Rewrite, add, delete the 0th IFD contents (TIFF)
- [ ] Rewrite, add, delete the 0th IFD contents (Exif)
- [ ] Rewrite, add, delete the 0th IFD contents (Interoperability)
- [ ] Rewrite, add, delete the 0th IFD contents (GPS)
- [ ] Delete all Exif information

## Usage
Please check out the Examples tab in pub.dev.

## Support
Basically no support.  
If you have any problem please open an issue on Github.
This package is low priority, but may be fixed.

## About version control
The C part will be changed at the time of version upgrade.  
However, versions less than 1.0.0 may change the file structure regardless of the following rules.  
- Changes such as adding variables, structure change that cause problems when reading previous files.
    - C.X.X
- Adding methods, etc.
    - X.C.X
- Minor changes and bug fixes.
    - X.X.C

## License
Copyright 2025 Masahide Mori

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Copyright notice
The “Dart” name and “Flutter” name are trademarks of Google LLC.  
*The developer of this package is not Google LLC.