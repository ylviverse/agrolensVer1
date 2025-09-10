import 'dart:io';
import 'package:agrolens/themes/color.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:lottie/lottie.dart';

class ResultPage extends StatefulWidget {
  final XFile capturedImage;

  const ResultPage({
    super.key,
    required this.capturedImage,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  bool _isAnalyzing = true;
  String? _prediction;
  double? _confidence;
  Map<String, dynamic>? _analysisResults;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    //_analyzeImage();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // TODO: Replace with actual CNN model integration
  // Future<void> _analyzeImage() async {
  //   setState(() {
  //     _isAnalyzing = true;
  //   });

  //   try {
  //     // Simulate analysis delay (replace with actual model loading time)
  //     await Future.delayed(const Duration(seconds: 3));
      
  //     // TODO: Replace this with actual CNN model prediction
  //     // final results = await _predictWithCNNModel(widget.capturedImage.path);
      
  //     // Mock results for testing (remove when CNN is integrated)
  //     final results = {
  //       'disease': 'Healthy',
  //       'confidence': 0.92,
  //       'severity': 'None',
  //     };
      
  //     setState(() {
  //       _prediction = results['disease'];
  //       _confidence = results['confidence'];
  //       _analysisResults = results;
  //       _isAnalyzing = false;
  //     });
      
  //     // Stop the loading animation
  //     _pulseController.stop();
  //   } catch (e) {
  //     setState(() {
  //       _prediction = 'Error analyzing image';
  //       _confidence = 0.0;
  //       _isAnalyzing = false;
  //     });
  //     _pulseController.stop();
  //   }
  // }

  // TODO: Implement actual CNN model prediction
  /*
  Future<Map<String, dynamic>> _predictWithCNNModel(String imagePath) async {
    // PLACEHOLDER: This is where you'll integrate your CNN model
    // Example using tflite_flutter or tensorflow_lite packages:
    
    // 1. Load the model
    // final interpreter = await Interpreter.fromAsset('assets/models/rice_disease_model.tflite');
    
    // 2. Preprocess the image
    // final preprocessedImage = await _preprocessImage(imagePath);
    
    // 3. Run inference
    // final output = List.filled(1 * numClasses, 0).reshape([1, numClasses]);
    // interpreter.run(preprocessedImage, output);
    
    // 4. Process results
    // final predictions = output[0] as List<double>;
    // final maxIndex = predictions.indexOf(predictions.reduce(math.max));
    // final confidence = predictions[maxIndex];
    // final disease = diseaseLabels[maxIndex];
    
    // return {
    //   'disease': disease,
    //   'confidence': confidence,
    //   'all_predictions': predictions,
    //   'severity': _getSeverity(disease, confidence),
    // };

    // Mock data for testing
    final mockDiseases = ['Healthy', 'Brown Spot', 'Leaf Blast', 'Bacterial Blight'];
    final mockDisease = mockDiseases[DateTime.now().millisecond % mockDiseases.length];
    final mockConfidence = 0.85 + (DateTime.now().millisecond % 15) / 100;

    return {
      'disease': mockDisease,
      'confidence': mockConfidence,
      'severity': mockDisease == 'Healthy' ? 'None' : 'Moderate',
    };
  }
  */

  // TODO: Add image preprocessing for CNN model
  /*
  Future<List<List<List<List<double>>>>> _preprocessImage(String imagePath) async {
    // 1. Load image
    // final imageFile = File(imagePath);
    // final image = img.decodeImage(imageFile.readAsBytesSync());
    
    // 2. Resize to model input size (e.g., 224x224)
    // final resized = img.copyResize(image!, width: 224, height: 224);
    
    // 3. Normalize pixel values to [0,1] or [-1,1] depending on model
    // final input = List.generate(1, (i) =>
    //   List.generate(224, (y) =>
    //     List.generate(224, (x) =>
    //       List.generate(3, (c) {
    //         final pixel = resized.getPixel(x, y);
    //         switch (c) {
    //           case 0: return pixel.r / 255.0; // Red
    //           case 1: return pixel.g / 255.0; // Green
    //           case 2: return pixel.b / 255.0; // Blue
    //           default: return 0.0;
    //         }
    //       })
    //     )
    //   )
    // );
    
    // return input;
  }
  */

  Color _getHealthColor(String disease) {
    switch (disease.toLowerCase()) {
      case 'healthy':
        return CupertinoColors.systemGreen;
      case 'brown spot':
      case 'leaf blast':
      case 'bacterial blight':
        return CupertinoColors.systemRed;
      default:
        return CupertinoColors.systemOrange;
    }
  }

  IconData _getHealthIcon(String disease) {
    switch (disease.toLowerCase()) {
      case 'healthy':
        return CupertinoIcons.checkmark_seal_fill;
      case 'brown spot':
      case 'leaf blast':
      case 'bacterial blight':
        return CupertinoIcons.exclamationmark_triangle_fill;
      default:
        return CupertinoIcons.question_circle_fill;
    }
  }

  Widget _buildLoadingAnimation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Lottie.asset(
            'assets/animations/Loading.json', 
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
        
        const SizedBox(height: 30),
        
        const Text(
          'Analyzing your rice...',
          style: TextStyle(
            fontSize: 24,
            color: CupertinoColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 12),
        
        const Text(
          'Please wait while our AI examines the image',
          style: TextStyle(
            fontSize: 16,
            color: CupertinoColors.white,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 30),
        
        // Progress indicator
        const CupertinoActivityIndicator(
          color: CupertinoColors.white,
          radius: 15,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CupertinoNavigationBarBackButton(
          color: CupertinoColors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Analysis Result',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.white,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: MyColor.greenish, 
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight + 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Captured Image Display
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(widget.capturedImage.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Loading Animation or Results
              if (_isAnalyzing) ...[
                _buildLoadingAnimation(),
              ] else ...[
                // Analysis Results
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getHealthIcon(_prediction ?? 'Unknown'),
                      color: _getHealthColor(_prediction ?? 'Unknown'),
                      size: 40,
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        _prediction == 'Healthy' 
                          ? 'Your rice looks healthy!' 
                          : 'Disease detected: $_prediction',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _getHealthColor(_prediction ?? 'Unknown'),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                if (_confidence != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Confidence: ${(_confidence! * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 18,
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],

                const SizedBox(height: 40),

                // Analysis Details Box
                if (_analysisResults != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: CupertinoColors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.info_circle,
                              color: CupertinoColors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Analysis Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_analysisResults!['severity'] != null) ...[
                          Text(
                            'Severity: ${_analysisResults!['severity']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: CupertinoColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const Text(
                          'Analysis completed using advanced image processing.',
                          style: TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.white,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}