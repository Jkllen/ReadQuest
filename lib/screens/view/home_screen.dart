import 'package:flutter/material.dart';
import 'package:read_quest/screens/view/read_screen.dart';
import 'package:read_quest/screens/view/rewards_screen.dart';
import 'package:read_quest/screens/widgets/home/home_tab.dart';
import 'package:read_quest/screens/view/stats_screen.dart';
import 'package:read_quest/screens/view/boss_fight_screen.dart'; // Make sure this matches your file name!

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void onTap(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeTab(
        onOpenReadTab: () => onTap(1),
      ),
      const ReadScreen(),
      const RewardsScreen(),
      const StatsScreen(),
    ];

    return Scaffold(
      // 1. We wrapped your pages in a Stack so the bubble can float on top
      body: Stack(
        children: [
          // The current tab content
          pages[currentIndex],
          
          // 2. The new draggable chat bubble!
          const DraggableBossBubble(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: const Color(0xFF2078FC),
        unselectedItemColor: const Color(0xFF999BA0),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Read"),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Rewards",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
        ],
      ),
    );
  }
}

// --- UPGRADED DRAGGABLE BUBBLE WITH PULSE & SNAP ---
class DraggableBossBubble extends StatefulWidget {
  const DraggableBossBubble({super.key});

  @override
  State<DraggableBossBubble> createState() => _DraggableBossBubbleState();
}

// Notice the 'SingleTickerProviderStateMixin' - this is required for animations!
class _DraggableBossBubbleState extends State<DraggableBossBubble> with SingleTickerProviderStateMixin {
  double xPosition = 0.0;
  double yPosition = 150.0;
  bool isDragging = false;
  bool isInitialized = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // 1. Set up the pulsing animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // How fast it pulses
    )..repeat(reverse: true); // Makes it go back and forth endlessly

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 2. Set the initial position to the right side of the screen
    if (!isInitialized) {
      xPosition = MediaQuery.of(context).size.width - 80;
      isInitialized = true;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose(); // Always clean up animations!
    super.dispose();
  }

  // 3. The logic that makes it snap like a Messenger chat head
  void _snapToEdge(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const double bubbleSize = 65.0;
    const double padding = 16.0;

    setState(() {
      isDragging = false; // Turn animation back on for the snap

      // Snap to Left or Right?
      if (xPosition < screenWidth / 2) {
        xPosition = padding; // Snap to Left
      } else {
        xPosition = screenWidth - bubbleSize - padding; // Snap to Right
      }

      // Prevent it from getting stuck too high or too low off-screen
      if (yPosition < 50) yPosition = 50;
      if (yPosition > screenHeight - 150) yPosition = screenHeight - 150;
    });
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedPositioned makes the "snap" smooth
    return AnimatedPositioned(
      // If dragging, duration is 0 so it follows your finger perfectly.
      // If snapping, it takes 300 milliseconds to fly to the edge.
      duration: isDragging ? Duration.zero : const Duration(milliseconds: 300),
      curve: Curves.easeOutBack, // Gives it a tiny bounce when it hits the edge
      left: xPosition,
      top: yPosition,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            isDragging = true;
            xPosition += details.delta.dx;
            yPosition += details.delta.dy;
          });
        },
        onPanEnd: _snapToEdge, // Triggers the snap when you let go
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BossFightScreen()),
          );
        },
        // AnimatedBuilder rebuilds just the shadow 60 times a second
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Material(
              color: Colors.transparent,
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE11D48), Colors.deepOrange], 
                  ),
                  border: Border.all(color: Colors.amber, width: 2),
                  boxShadow: [
                    // Base shadow
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                    // Pulsing glowing shadow
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.8),
                      blurRadius: 10 + (_pulseAnimation.value * 20), // Grows and shrinks
                      spreadRadius: _pulseAnimation.value * 8, // Grows and shrinks
                    )
                  ],
                ),
                child: Center(
                  // We rotate the 'colorize' icon to make it look like a sword!
                  child: Transform.rotate(
                    angle: 2.356, // roughly 135 degrees
                    child: const Icon(
                      Icons.colorize, 
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}