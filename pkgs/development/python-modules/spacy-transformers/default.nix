{ lib
, callPackage
, fetchPypi
, buildPythonPackage
, dataclasses
, pytorch
, pythonOlder
, spacy
, spacy-alignments
, srsly
, transformers
}:

buildPythonPackage rec {
  pname = "spacy-transformers";
  version = "1.1.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-egWhcrfR8B6l7ji0KOzuMz18YZepNb/ZQz5S0REo9Hc=";
  };

  propagatedBuildInputs = [
    pytorch
    spacy
    spacy-alignments
    srsly
    transformers
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "transformers>=3.4.0,<4.18.0" "transformers>=3.4.0 # ,<4.18.0"
  '';

  # Test fails due to missing arguments for trfs2arrays().
  doCheck = false;

  pythonImportsCheck = [
    "spacy_transformers"
  ];

  passthru.tests.annotation = callPackage ./annotation-test { };

  meta = with lib; {
    description = "spaCy pipelines for pretrained BERT, XLNet and GPT-2";
    homepage = "https://github.com/explosion/spacy-transformers";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
