import 'package:flutter_artist/flutter_artist.dart';
import 'package:flutter_test/flutter_test.dart';

// Dummy Domain Classes for Unit Testing
abstract class Product {}

class ProductInfo implements Product {}

class ProductData implements Product {}

class ProductDetailData implements Product {}

abstract class Supplier {}

class SupplierInfo implements Supplier {}

abstract class Program {}

class ProgramInfo implements Program {}

class ProgramData implements Program {}

abstract class ProgramContributor {}

class ProgramContributorInfo implements ProgramContributor {}

void main() {
  group('BlockEventDispatchPlanResolver Tests', () {
    // =========================================================================
    // 1. UNRELATED EVENTS (NO-OP / IGNORE)
    // =========================================================================
    test(
        'Should return ignore plan when listener does not react to emitted types',
        () {
      final plan = BlockEventDispatchPlanResolver.resolvePlan<int>(
        eventMainResolvedTypes: {ProductInfo, ProductData},
        eventExtraResolvedTypes: {},
        sourceEffectedItemIds: [1, 2],
        listenerTargetTypes: {ProgramInfo},
        listenerReactionTypes: {ProgramInfo}, // Completely unrelated
      );

      expect(plan.shouldDispatch, isFalse);
      expect(plan.isSameDomainFamily, isFalse);
      expect(plan.effectiveItemIds, isNull);
      expect(plan.requiresMaxSyncStrategy, isFalse);
    });

    // =========================================================================
    // 2. UNIFORM DOMAIN DISPATCH (SAME PROJECTION FAMILY)
    // =========================================================================
    test(
        'Should allow targeted ID sync when listener shares the same domain family',
        () {
      final plan = BlockEventDispatchPlanResolver.resolvePlan<int>(
        // Source emitted ProductInfo (resolved with its family members)
        eventMainResolvedTypes: {ProductInfo, ProductData, ProductDetailData},
        eventExtraResolvedTypes: {},
        sourceEffectedItemIds: [101, 102],
        // Listener exposes ProductData (same family)
        listenerTargetTypes: {ProductData},
        listenerReactionTypes: {ProductInfo},
      );

      expect(plan.shouldDispatch, isTrue);
      expect(plan.isSameDomainFamily, isTrue);
      expect(plan.effectiveItemIds, equals([101, 102]));
      expect(plan.requiresMaxSyncStrategy, isFalse);
    });

    // =========================================================================
    // 3. CROSS-DOMAIN DISPATCH (ID MISMATCH ESCALATION - e.g. TEST CASE 75a)
    // =========================================================================
    test(
        'Should escalate to MAX Strategy and strip IDs when crossing domain boundaries',
        () {
      // Child block emits Contributor IDs
      final plan = BlockEventDispatchPlanResolver.resolvePlan<int>(
        eventMainResolvedTypes: {ProgramContributorInfo},
        eventExtraResolvedTypes: {},
        sourceEffectedItemIds: [
          999
        ], // Contributor ID (must not leak into Program)
        // Parent block exposes ProgramInfo and observes Contributor mutations
        listenerTargetTypes: {ProgramInfo},
        listenerReactionTypes: {ProgramContributorInfo},
      );

      expect(plan.shouldDispatch, isTrue);
      expect(plan.isSameDomainFamily, isFalse);
      expect(plan.effectiveItemIds, isNull); // Stripped!
      expect(plan.requiresMaxSyncStrategy, isTrue); // Escalated!
    });

    // =========================================================================
    // 4. CROSS-DOMAIN WITH EMPTY EFFECTED IDS (TEST CASE 75a ZERO REMAINDER)
    // =========================================================================
    test(
        'Should still dispatch with MAX Strategy when sourceEffectedItemIds is empty',
        () {
      // Child action created 0 remainder contributors -> []
      final plan = BlockEventDispatchPlanResolver.resolvePlan<int>(
        eventMainResolvedTypes: {ProgramContributorInfo},
        eventExtraResolvedTypes: {},
        sourceEffectedItemIds: [], // Empty list from server response
        listenerTargetTypes: {ProgramInfo},
        listenerReactionTypes: {ProgramContributorInfo},
      );

      expect(plan.shouldDispatch, isTrue);
      expect(plan.isSameDomainFamily, isFalse);
      expect(plan.effectiveItemIds, isNull);
      expect(plan.requiresMaxSyncStrategy, isTrue);
    });

    // =========================================================================
    // 5. AUXILIARY / EXTRA EVENT ESCALATION
    // =========================================================================
    test('Should escalate to MAX Strategy when matching on extra event branch',
        () {
      final plan = BlockEventDispatchPlanResolver.resolvePlan<int>(
        eventMainResolvedTypes: {ProductInfo},
        eventExtraResolvedTypes: {SupplierInfo}, // Extra event emitted
        sourceEffectedItemIds: [10],
        listenerTargetTypes: {SupplierInfo},
        listenerReactionTypes: {SupplierInfo},
      );

      expect(plan.shouldDispatch, isTrue);
      expect(plan.isSameDomainFamily, isFalse);
      expect(plan.effectiveItemIds, isNull);
      expect(plan.requiresMaxSyncStrategy, isTrue);
    });

    // =========================================================================
    // 6. MULTI-EVENT CONFLICT RESOLUTION (STRATEGY ESCALATION BOTTLENECK)
    // =========================================================================
    test(
        'Should escalate to MAX Strategy when listener reacts to both Main and Extra events',
        () {
      // Source emits ProductInfo (Main with IDs) + SupplierInfo (Extra without IDs)
      // Listener manages Product, but observes BOTH Product and Supplier
      final plan = BlockEventDispatchPlanResolver.resolvePlan<int>(
        eventMainResolvedTypes: {ProductInfo, ProductData},
        eventExtraResolvedTypes: {SupplierInfo},
        sourceEffectedItemIds: [1, 2, 3],
        listenerTargetTypes: {ProductInfo, ProductData},
        listenerReactionTypes: {ProductInfo, SupplierInfo},
      );

      // Even though ProductInfo is same-family, the presence of SupplierInfo forces MAX Strategy
      expect(plan.shouldDispatch, isTrue);
      expect(plan.isSameDomainFamily, isFalse);
      expect(plan.effectiveItemIds, isNull);
      expect(plan.requiresMaxSyncStrategy, isTrue);
    });

    // =========================================================================
    // 7. SAME DOMAIN WITH EMPTY EFFECTED IDS
    // =========================================================================
    test(
        'Should keep requiresMaxSyncStrategy false but pass null IDs when source list is empty',
        () {
      final plan = BlockEventDispatchPlanResolver.resolvePlan<int>(
        eventMainResolvedTypes: {ProductInfo, ProductData},
        eventExtraResolvedTypes: {},
        sourceEffectedItemIds: [],
        listenerTargetTypes: {ProductData},
        listenerReactionTypes: {ProductInfo},
      );

      expect(plan.shouldDispatch, isTrue);
      expect(plan.isSameDomainFamily, isTrue);
      expect(plan.effectiveItemIds, isNull);
      expect(plan.requiresMaxSyncStrategy, isFalse);
    });
  });
}
