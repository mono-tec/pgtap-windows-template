# pgTAP for Windows – version 1.3.5

## 概要
このフォルダには Windows 版 PostgreSQL 用の pgTAP 拡張一式が含まれています。

- **pgtap.control** … 拡張メタ情報  
- **pgtap--1.3.5.sql** … 拡張本体スクリプト  
- **install_pgtap_windows.bat** … 管理者権限で実行し、PostgreSQL に登録します。
- **uninstall_pgtap_windows.bat** … 対応バージョンの pgTAP を PostgreSQL から削除します。  
  （共通ファイル *pgtap.control* は削除されません）

## 使用方法
1. PostgreSQL を停止していない状態で  
   `install_pgtap_windows.bat` を **管理者として実行**
2. psql で以下を実行：
   ```sql
   CREATE EXTENSION IF NOT EXISTS pgtap;
   ```

---

## License
pgTAP is distributed under the **PostgreSQL License (BSD-like)**.

```
Copyright (c) 2008–2025 David E. Wheeler.  
Some rights reserved.

Permission to use, copy, modify, and distribute this software and its documentation
for any purpose, without fee, and without a written agreement is hereby granted,
provided that the above copyright notice and this paragraph and the following two
paragraphs appear in all copies.

IN NO EVENT SHALL DAVID E. WHEELER BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT
OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF DAVID E. WHEELER HAS
BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

DAVID E. WHEELER SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND DAVID E. WHEELER HAS
NO OBLIGATIONS TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
```
