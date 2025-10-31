# pgTAP on Windows — Ready-to-Use Template

Windows 環境で **pgTAP** を簡単に導入・テストできるテンプレートです。  
Linux や Docker 環境で一度だけビルドし、生成されたファイルを Windows に配置して利用します。

> 💡 参考記事（Zenn）: 追記予定

---

## 🚀 クイックスタート

1. **`build/` に以下を配置**  
   （例: PostgreSQL 17 用の `share\extension` から取得）

   ```
   pgtap.control
   pgtap--1.3.5.sql
   uninstall_pgtap_windows.bat
   install_pgtap_windows.bat
   ```

2. **pgTAP をインストール**
   ```bat
   build\1.3.5\install_pgtap_windows.bat
   ```

3. **テスト環境を初期構築**
   ```bat
   example\init.bat
   ```

4. **テスト実行**
   ```bat
   example\test_all.bat
   ```

5. **結果確認**
   ログは `example\logs\<日付>` に保存されます。

---

## 🧩 フォルダ構成

```
ROOT:.
│  .gitignore
│  README.md
│
├─build
│  │  .keep
│  │
│  └─1.3.5
│          install_pgtap_windows.bat
│          pgtap--1.3.5.sql
│          pgtap.control
│          README.md
│          uninstall_pgtap_windows.bat
│
└─example
    │  init.bat
    │
    ├─logs
    │  └─YYYYMMDD
    │          pgtap_example_HHMMSS.log
    │
    ├─sql
    │      .keep
    │      create_testdb.sql
    │      drop_testdb.sql
    │      enable_pgtap.sql
    │      test_sample.sql
    │
    ├─template
    │      create_testdb.sql.tmpl
    │      drop_testdb.sql.tmpl
    │      enable_pgtap.sql.tmpl
    │      run_tests.bat.tmpl
    │      test_all.bat.tmpl
    │      test_sample.sql.tmpl
    │
    └─tools
            InnoReplacer.exe
```

---

## 🏗️ build フォルダについて

`build` フォルダには **pgTAP のコンパイル済み生成物** を配置しています。  
バージョンごとにサブディレクトリを作成し、`1.3.5` のように整理します。  

- 例: `build\1.3.5\pgtap--1.3.5.sql`
- 今後の更新予定は未定ですが、新バージョンを適用する場合は同階層に追加してください。

これにより、複数バージョンを並行して管理し、PostgreSQL 環境ごとの検証が容易になります。

---

## ⚙️ 動作概要

- **`init.bat`**  
  テンプレートから実行ファイルを生成（`InnoReplacer.exe` 使用）。  
  SQL は UTF-8（無BOM）、バッチファイルは Shift-JIS で生成。

- **`test_all.bat`**  
  テストDBを作成 → `pgTAP`拡張を有効化 → テスト実行 → 後片付け。

- **`run_tests.bat`**  
  `pg_prove` または `psql` を用いて単体テストを実施。

---

## 📘 注意事項

- PostgreSQL のバージョンによって `share\extension` の位置が異なります。  
  `install_pgtap_windows.bat` 内の `PGROOT` を環境に合わせて変更してください。

- `pg_prove` がインストールされていない場合は自動的に `psql` で代替されます。

- `InnoReplacer.exe` によって文字コードを維持したまま置換を行います。  
  SQL: UTF-8（無BOM）／BAT: Shift-JIS。

---

## 🔐 配布物整合性チェック（InnoReplacer.exe）

このテンプレートで利用している `InnoReplacer.exe` は、
文字コードを保持したままテンプレートファイルを置換するユーティリティです。

配布ファイルの整合性を確認するには、以下のコマンドを実行します：

```powershell
CertUtil -hashfile example\tools\InnoReplacer.exe SHA256
```

実行結果の例：
```
SHA256 ハッシュ (対象 InnoReplacer.exe):
c12b4ee67b0ee0aa4d9922ddb36293504b9887992f6c9a1d7b877d1263bc4458
CertUtil: -hashfile コマンドは正常に完了しました。
```

✅ **この SHA256 値**
```
c12b4ee67b0ee0aa4d9922ddb36293504b9887992f6c9a1d7b877d1263bc4458
```

この値と一致していれば、正規の配布物であることを確認できます。

> 備考:
> - `InnoReplacer.exe` は mono-tec/InnoReplacer でソース公開予定です。
> - SQL テンプレートは UTF-8（無BOM）、BAT テンプレートは Shift-JIS を維持して生成されます。

---

## ⚖️ ライセンス

pgTAP は **PostgreSQL License（BSD 系）** で配布されています。  
このテンプレートでは、`build/1.3.5/README.md` にライセンス表記を含めています。  
再配布する場合は、このファイルを同梱してください。  

ツール **InnoReplacer** は © 2025 mono-tec により開発・配布されています（MIT License）。

