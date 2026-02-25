# MINST-ONNX_to_RTL

# Extract Quantization Point

Automatically detect the quantization integer type (int4, int8 or int16) from a quantized model and convert ONNX models to RTL and .mem files in one workflow

## ONNX to RTL

`minst_onnx_to_RTL.py`:

```bash
# Convert ONNX to RTL + .mem (quantization autodetected from model)
python minst_onnx_to_RTL.py --onnx-model path/to/model.onnx --out-dir ./my_ip

# With testbench
python minst_onnx_to_RTL.py --onnx-model model.onnx --out-dir ./output --emit-testbench

# Override autodetection
python minst_onnx_to_RTL.py --onnx-model model.onnx --out-dir ./output --weight-format int8
```

## Quantization Detection

### Command line

```bash
# From model source (e.g QuantizedMNISTNet.py)
python detect_quant_type.py --model-module "...."

# From .mem files
python detect_quant_type.py --mem-dir path/to/mem/files

# From params_report.json
python detect_quant_type.py --report path/to/params_report.json

# From ONNX model
python detect_quant_type.py --onnx-model path/to/model.onnx

# From checkpoint
python detect_quant_type.py --checkpoint path/to/model.pth

# Search a directory for report or .mem files
python detect_quant_type.py --search-dir path/to/output
```

### Integration 

```python
from pathlib import Path
from detect_quant_type import detect_quantization_type, quant_type_to_bits

# Autodetect from model source
qt = detect_quantization_type(model_module=Path("QuantizedMNISTNet.py"))
# qt is "int4 ,int8 or int16"

# Or from ONNX
qt =detect_quantization_type(onnx_path=Path("model.onnx"))

bits =quant_type_to_bits(qt)  # 4, 8 or 16
```

## Detection order

1. **params_report.json** – if the model was exported with `export_params_to_mem.py`
2. **.mem files** – hex digit width per line (1→int4, 2→int8, 4→int16)
3. **ONNX model** – value types (INT4, INT8, INT16, UINT4, UINT8, UINT16)
4. **Checkpoint** – tensor dtypes (int8, int16)
5. **Model source** – patterns like `float_to_int16`, `0xFFFF`, `-32768`
6. If detection fails, the default is **int16**


## Dependencies

- **Python 3.8+**
- **PyTorch** – optional, only needed for checkpoint  detection
- **ONNX** – optional, only needed for ONNX model detection
