import com.mojang.blaze3d.vertex.PoseStack;
import io.netty.channel.embedded.EmbeddedChannel;
import net.minecraft.client.model.effects.SpearAnimations;
import net.minecraft.core.component.DataComponents;
import net.minecraft.core.registries.Registries;
import net.minecraft.gametest.framework.GameTestHelper;
import net.minecraft.gametest.framework.TestFunctionLoader;
import net.minecraft.network.Connection;
import net.minecraft.network.protocol.PacketFlow;
import net.minecraft.network.protocol.game.ServerboundClientCommandPacket;
import net.minecraft.network.protocol.game.ServerboundPlayerLoadedPacket;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.server.network.CommonListenerCookie;
import net.minecraft.world.InteractionHand;
import net.minecraft.world.entity.EquipmentSlot;
import net.minecraft.world.entity.HumanoidArm;
import net.minecraft.world.entity.ai.attributes.Attributes;
import net.minecraft.world.entity.monster.cubemob.SulfurCube;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.level.GameType;
import net.minecraft.world.level.entity.EntityTypeTest;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

public class PlayerMechanicsTest {
    static void copyTree(Path src, Path dst) {
        try (var stream = Files.walk(src)) {
            for (var p : stream.toList()) {
                var target = dst.resolve(src.relativize(p));
                if (Files.isDirectory(p)) {
                    Files.createDirectories(target);
                } else {
                    Files.createDirectories(target.getParent());
                    Files.copy(p, target, StandardCopyOption.REPLACE_EXISTING);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static void main(String[] args) throws Exception {
        net.minecraft.SharedConstants.tryDetectVersion();
        TestFunctionLoader.registerLoader(register -> register.accept(
            ResourceKey.create(Registries.TEST_FUNCTION, Identifier.parse("sc_test:player")), PlayerMechanicsTest::run));
        var templateProp = System.getProperty("sc.templateWorld", System.getProperty("mc.templateWorld"));
        net.minecraft.gametest.framework.GameTestMainUtil.runGameTestServer(args, universe -> {
            if (templateProp != null && !templateProp.isEmpty()) {
                copyTree(Path.of(templateProp), Path.of(universe, "gametestworld"));
            }
        });
    }

    static void command(ServerPlayer p, String line) {
        var server = p.level().getServer();
        server.getCommands().performPrefixedCommand(server.createCommandSourceStack().withEntity(p).withPosition(p.position()).withSuppressedOutput(), line);
    }

    static SulfurCube whiteBall(ServerPlayer p, String tag, String pos) {
        command(p, "summon minecraft:sulfur_cube " + pos
                + " {Size:1,Tags:[\"sc_ball\",\"" + tag + "\"],equipment:{body:{id:\"minecraft:tnt\",count:1}}}");
        command(p, "execute as @e[tag=" + tag + "] at @s run function sc:cube/init");
        return p.level().getEntities(EntityTypeTest.forClass(SulfurCube.class), c -> c.entityTags().contains(tag)).getFirst();
    }

    static int score(SulfurCube ball, String name) {
        var board = ball.level().getScoreboard();
        return board.getPlayerScoreInfo(ball, board.getObjective(name)).value();
    }

    static int matchScore(ServerPlayer p, String name) {
        var board = p.level().getScoreboard();
        return board.getPlayerScoreInfo(net.minecraft.world.scores.ScoreHolder.forNameOnly(name), board.getObjective("sc_var")).value();
    }

    static void owner(ServerPlayer p, String tag, int team, int fuse) {
        command(p, "scoreboard players set @e[tag=" + tag + "] sc_team " + team);
        command(p, "scoreboard players set @e[tag=" + tag + "] sc_fuse " + fuse);
    }

    static void checkDashShot(GameTestHelper h, ServerPlayer p) {
        p.getInventory().setSelectedSlot(1);
        var spear = p.getMainHandItem();
        var dash = spear.get(DataComponents.PIERCING_WEAPON);
        var kinetic = spear.get(DataComponents.KINETIC_WEAPON);
        for (var c : java.util.List.of(kinetic.damageConditions(), kinetic.knockbackConditions(), kinetic.dismountConditions()))
            h.assertTrue(!c.orElseThrow().test(5, 1, 1, 1), "gold gravity allowed a native charge hit");
        p.snapTo(0.5, 65, 0.5, 0, 25);
        p.setYHeadRot(0);
        var neutral = whiteBall(p, "sc_test_gold_white", "0.5 65 1.1");
        var enemy = whiteBall(p, "sc_test_gold_enemy", "0.5 65 1.7");
        var own = whiteBall(p, "sc_test_gold_own", "0.5 65 2.45");
        var second = whiteBall(p, "sc_test_gold_second", "0.5 65 3");
        var side = whiteBall(p, "sc_test_gold_side", "1.65 65 1.2");
        owner(p, "sc_test_gold_enemy", 2, 40);
        owner(p, "sc_test_gold_own", 1, 21);
        owner(p, "sc_test_gold_second", 1, 40);
        owner(p, "sc_test_gold_side", 1, 40);
        p.getFoodData().setFoodLevel(6);
        dash.attack(p, EquipmentSlot.MAINHAND);
        h.assertTrue(!own.entityTags().contains("sc_impact"), "low-food swing still fired a ball");
        p.getFoodData().setFoodLevel(8);
        command(p, "setblock 0 65 1 stone_bricks");
        dash.attack(p, EquipmentSlot.MAINHAND);
        h.assertTrue(!own.entityTags().contains("sc_impact"), "gold thrust reached through wall");
        command(p, "setblock 0 65 1 air");
        command(p, "effect clear @s");
        for (int i = 0; i < 5; i++) p.doTick(); // Settle exhaustion from the separate blocked thrust.
        p.getFoodData().setFoodLevel(7);
        p.setDeltaMovement(0, 0, 0);
        dash.attack(p, EquipmentSlot.MAINHAND);
        h.assertTrue(p.getDeltaMovement().horizontalDistanceSqr() > 0.1 && own.entityTags().contains("sc_impact")
                && own.isAlive() && score(own, "sc_team") == 1 && score(own, "sc_fuse") == 21,
                "gold left-click must lunge and fire without changing team/fuse at 7 food: tags=" + own.entityTags());
        var v = own.getDeltaMovement();
        h.assertTrue(Math.abs(v.x) < 0.002 && v.y == 0 && Math.abs(v.z - 0.875) < 0.002, "not a level speed-scaled shot: " + v);
        for (int i = 0; i < 3; i++) p.doTick();
        h.assertTrue(p.getFoodData().getFoodLevel() == 5, "a successful gold shot must cost exactly one dash");
        command(p, "function sc:player/alive_step");
        h.assertTrue(!second.entityTags().contains("sc_impact") && !side.entityTags().contains("sc_impact")
                && !enemy.entityTags().contains("sc_impact") && score(enemy, "sc_fuse") == 40
                && enemy.getDeltaMovement().lengthSqr() == 0 && neutral.getDeltaMovement().lengthSqr() == 0
                && score(neutral, "sc_team") == 0 && score(neutral, "sc_fuse") == -1, "thrust affected non-targets");
        neutral.discard(); enemy.discard(); second.discard(); side.discard();
        // Move the shooter into the ball's path; it must pass its teammate and the floor.
        p.snapTo(0.5, 65, 2.9, 0, 0);
        command(p, "execute as @e[tag=sc_test_gold_own] at @s run function sc:cube/step");
        h.assertTrue(own.isAlive() && !own.entityTags().contains("sc_exploding") && score(own, "sc_fuse") == 20,
                "floor/teammate triggered the shot, or fuse did not count down");
        command(p, "setblock 0 65 4 stone_bricks");
        for (int i = 0; i < 4 && own.isAlive(); i++) {
            command(p, "execute as @e[tag=sc_test_gold_own] at @s run function sc:cube/step");
            if (own.isAlive()) own.tick();
        }
        h.assertTrue(own.entityTags().contains("sc_exploding") && !own.isAlive()
                && p.level().getBlockState(new net.minecraft.core.BlockPos(0, 65, 4)).is(net.minecraft.world.level.block.Blocks.STONE_BRICKS),
                "shot bounced or destroyed fixed wall");
        command(p, "setblock 0 65 4 air");
        command(p, "kill @e[type=wind_charge]");
        // A miss can still connect during movement, but only inside the brief thrust window.
        p.snapTo(0.5, 65, 0.5, 0, 0);
        p.getFoodData().setFoodLevel(20);
        var late = whiteBall(p, "sc_test_gold_late", "0.5 65 4.5");
        owner(p, "sc_test_gold_late", 1, 1);
        dash.attack(p, EquipmentSlot.MAINHAND);
        h.assertTrue(!late.entityTags().contains("sc_impact"), "out-of-reach ball fired on press");
        p.snapTo(0.5, 65, 2, 0, 0);
        command(p, "function sc:player/alive_step");
        h.assertTrue(late.entityTags().contains("sc_impact"), "ball crossing the tip during movement was missed");
        command(p, "execute as @e[tag=sc_test_gold_late] at @s run function sc:cube/step");
        h.assertTrue(!late.isAlive(), "impact shot outlived its original fuse");
        command(p, "kill @e[type=wind_charge]");
    }

    static void checkEndless(GameTestHelper h, ServerPlayer p) {
        var server = h.getLevel().getServer();
        var blue = new ServerPlayer(server, h.getLevel(), new com.mojang.authlib.GameProfile(java.util.UUID.randomUUID(), "sc-test-blue"),
                net.minecraft.server.level.ClientInformation.createDefault());
        var connection = new Connection(PacketFlow.SERVERBOUND);
        new EmbeddedChannel(connection);
        server.getPlayerList().placeNewPlayer(connection, blue, CommonListenerCookie.createInitial(blue.getGameProfile(), false));
        blue.connection.handleAcceptPlayerLoad(new net.minecraft.network.protocol.game.ServerboundPlayerLoadedPacket());
        command(blue, "team join blue @s");
        command(p, "scoreboard players set @s sc_set 13100101");
        command(p, "function sc:cfg/apply_rules");
        command(p, "function sc:game/start");
        command(p, "function sc:game/begin_fight");
        h.assertTrue(matchScore(p, "#cfg_dur") == 0 && matchScore(p, "#live_red") == 1 && matchScore(p, "#live_blue") == 1,
                "endless did not start with the live roster");
        var ball = whiteBall(p, "sc_test_endless_fuse", "0.5 65 0.5");
        command(p, "scoreboard players set @e[tag=sc_test_endless_fuse] sc_fuse 25");
        for (int ticks : new int[]{601, 501, 401, 301, 201, 101, 1, 0}) {
            command(p, "scoreboard players set #rem_ticks sc_var " + ticks);
            command(p, "function sc:game/active_tick");
            h.assertTrue(matchScore(p, "#state") == 2 && matchScore(p, "#collapse_stage") == 0 && matchScore(p, "#rem_ticks") == ticks,
                    "endless ran the clock, shrank or timed out");
        }
        h.assertTrue(score(ball, "sc_fuse") == 17, "endless mode stopped ball updates");
        // A primed shot can be parried with the actual diamond spear; contact with a live enemy bursts it.
        var shot = whiteBall(p, "sc_test_blue_impact", "0.5 65.76 2.5");
        owner(p, "sc_test_blue_impact", 1, 35);
        command(p, "tag @e[tag=sc_test_blue_impact] add sc_impact");
        blue.snapTo(0.5, 65, 0.5, 0, 0);
        blue.setYHeadRot(0);
        shot.setDeltaMovement(0, 0, -0.75);
        blue.getInventory().setSelectedSlot(0);
        command(blue, "function sc:player/on_charge_use");
        h.assertTrue(shot.isAlive() && !shot.entityTags().contains("sc_impact") && score(shot, "sc_team") == 2 && score(shot, "sc_fuse") == 35,
                "legal parry failed to disarm impact mode or changed fuse");
        owner(p, "sc_test_blue_impact", 1, 10);
        command(p, "tag @e[tag=sc_test_blue_impact] add sc_impact");
        command(p, "scoreboard players set @e[tag=sc_test_blue_impact] sc_swap_cd 0");
        shot.setDeltaMovement(0, 0, -1.25);
        command(blue, "function sc:player/on_charge_use");
        h.assertTrue(shot.entityTags().contains("sc_impact") && score(shot, "sc_team") == 1, "parry disarmed a fuse-locked ball");
        command(p, "execute as @e[tag=sc_test_blue_impact] at @s run function sc:cube/step");
        h.assertTrue(!shot.isAlive() && shot.entityTags().contains("sc_exploding") && blue.isAlive(),
                "direct shot did not burst on enemy body");
        command(p, "kill @e[type=wind_charge]");
        command(p, "fill -14 64 -10 14 64 10 blue_concrete");
        h.assertTrue(server.getRespawnData().pos().equals(new net.minecraft.core.BlockPos(0, 70, -17)),
                "install did not set the lobby spawn");
        command(blue, "kill @s");
        h.assertTrue(blue.isDeadOrDying(), "expected a real death before respawn");
        var oldBlue = blue;
        blue.connection.handleClientCommand(new ServerboundClientCommandPacket(ServerboundClientCommandPacket.Action.PERFORM_RESPAWN));
        blue = oldBlue.connection.player;
        h.assertTrue(blue != oldBlue && !blue.isDeadOrDying(), "client respawn did not replace the dead player");
        h.assertTrue(blue.getX() == 0.5 && blue.getY() == 70 && blue.getZ() == -16.5
                && !blue.level().noCollision(blue, blue.getBoundingBox().move(0, -0.01, 0)),
                "native respawn must already be standing on the lobby pad before any teleport: " + blue.position());
        blue.connection.handleAcceptPlayerLoad(new ServerboundPlayerLoadedPacket());
        command(p, "function sc:game/active_tick");
        command(p, "execute unless data storage sc:game {result:{color:\"red\"}} run tag @s add sc_test_wrong_result");
        h.assertTrue(matchScore(p, "#state") == 0 && !p.entityTags().contains("sc_test_wrong_result") && p.getY() == 70 && blue.getY() == 70,
                "elimination must beat territory and return both teams");
        blue.snapTo(-4.5, 69, -12.5, 0, 0);
        command(blue, "function sc:lobby/ensure_present");
        h.assertTrue(blue.getX() == -4.5 && blue.getY() == 69 && blue.getZ() == -12.5,
                "player already watching from the north veranda should stay there");

        command(p, "function sc:cfg/defaults");
        command(p, "function sc:game/start");
        command(p, "function sc:game/begin_fight");
        command(p, "scoreboard players set #rem_ticks sc_var 601");
        command(p, "function sc:game/active_tick");
        h.assertTrue(matchScore(p, "#cfg_dur") == 90 && matchScore(p, "#collapse_stage") == 1, "timed mode did not resume shrinking");
        command(p, "scoreboard players set #rem_ticks sc_var 1");
        command(p, "function sc:game/active_tick");
        h.assertTrue(matchScore(p, "#state") == 0, "timed mode did not resume territory adjudication");
    }

    static void checkFloorGrace(GameTestHelper h, ServerPlayer p) {
        p.snapTo(0.5, 65, 0.5, 0, 0);
        for (int option = 0; option < 4; option++) {
            command(p, "scoreboard players set #o_grace sc_var " + option);
            command(p, "function sc:cfg/calc");
            command(p, "setblock 0 64 0 blue_concrete");
            command(p, "scoreboard players set @s sc_burn_cd 0");
            p.setHealth(20);
            p.setOnGround(true);
            for (int t = 1; t < 5 * (1 + option); t++) command(p, "function sc:player/floor_burn_tick");
            h.assertTrue(p.getHealth() == 20, "floor damage before selected threshold");
            p.setOnGround(false);
            command(p, "function sc:player/floor_burn_tick");
            p.setOnGround(true);
            command(p, "function sc:player/floor_burn_tick");
            var board = p.level().getScoreboard();
            h.assertTrue(p.getHealth() == 17, "first burn at option " + option + ": HP=" + p.getHealth()
                    + ", warn=" + board.getPlayerScoreInfo(p, board.getObjective("sc_burn_warn")).value()
                    + ", cooldown=" + board.getPlayerScoreInfo(p, board.getObjective("sc_burn_cd")).value()
                    + ", tags=" + p.entityTags() + ", effects=" + p.getActiveEffects());
            for (int t = 1; t < 9; t++) command(p, "function sc:player/floor_burn_tick");
            h.assertTrue(p.getHealth() == 17, "burn repeated before 9 ticks");
            command(p, "function sc:player/floor_burn_tick");
            h.assertTrue(p.getHealth() == 14, "grace changed burn interval");
            command(p, "setblock 0 64 0 light_gray_concrete");
            command(p, "function sc:player/floor_burn_tick");
            h.assertTrue(board.getPlayerScoreInfo(p, board.getObjective("sc_burn_warn")).value() == 0,
                    "neutral floor did not reset grace");
        }
        p.setHealth(20);
        command(p, "function sc:cfg/defaults");
    }

    static void checkServe(GameTestHelper h, ServerPlayer p) {
        command(p, "random reset sc:serve 42 false false");
        command(p, "scoreboard players set #need_balls sc_var 2");
        var angles = new java.util.HashSet<Integer>();
        for (int i = 0; i < 16; i++) {
            command(p, "function sc:cube/launch_dispatch");
            var balls = p.level().getEntities(EntityTypeTest.forClass(SulfurCube.class), b -> b.entityTags().contains("sc_ball") && b.isAlive());
            h.assertTrue(balls.size() == 2, "wrong pair count");
            var north = balls.stream().filter(b -> b.getZ() < 0).findFirst().orElseThrow();
            var south = balls.stream().filter(b -> b.getZ() > 0).findFirst().orElseThrow();
            var v = north.getDeltaMovement();
            var w = south.getDeltaMovement();
            var angle = (int) Math.round(Math.toDegrees(Math.atan2(v.x, v.z)));
            angles.add(angle);
            h.assertTrue(Math.abs(angle) >= 15 && Math.abs(angle) <= 50 && v.z > 0 && w.z < 0, "serve aimed outside cone");
            h.assertTrue(Math.abs(v.x + w.x) < 0.003 && Math.abs(v.z + w.z) < 0.003, "pair not mirrored");
            h.assertTrue(Math.abs(v.horizontalDistance() - 0.476) < 0.003 && Math.abs(w.horizontalDistance() - 0.476) < 0.003,
                    "random heading changed the configured 70% shot speed");
            balls.forEach(SulfurCube::discard);
        }
        h.assertTrue(angles.size() >= 4 && angles.stream().anyMatch(a -> a < 0) && angles.stream().anyMatch(a -> a > 0),
                "repeated dispatches in the same tick did not vary left/right and angle");
        command(p, "function sc:arena/collapse_step");
        command(p, "scoreboard players set #need_balls sc_var 1");
        for (double z : new double[]{-8.2, 9.2}) {
            command(p, "function sc:cube/launch_dispatch");
            var balls = p.level().getEntities(EntityTypeTest.forClass(SulfurCube.class), b -> b.entityTags().contains("sc_ball") && b.isAlive());
            h.assertTrue(balls.size() == 1 && Math.abs(balls.getFirst().getZ() - z) < 0.001, "single serve missed alternating shrink-wall port");
            h.assertTrue(z * balls.getFirst().getDeltaMovement().z < 0, "single serve did not travel inwards");
            var ball = balls.getFirst();
            ball.tick();
            h.assertTrue(Math.abs(ball.getAttributeValue(Attributes.BOUNCINESS) - 0.95) < 0.0001
                    && Math.abs(ball.getAttributeValue(Attributes.FRICTION_MODIFIER) - 0.10) < 0.0001
                    && Math.abs(ball.getAttributeValue(Attributes.AIR_DRAG_MODIFIER) - 0.02) < 0.0001,
                    "TNT ball did not receive its registered arena physics");
            balls.getFirst().discard();
        }
    }

    static void checkParrySetting(GameTestHelper h, ServerPlayer p) {
        var ball = whiteBall(p, "sc_test_parry_setting", "0.5 65 0.5");
        command(p, "scoreboard players set #hitter_team sc_var 1");
        command(p, "scoreboard players set #fx sc_var 1000");
        command(p, "scoreboard players set #fz sc_var 0");
        command(p, "scoreboard players set #pvz sc_var 0");
        for (int option = 0; option < 4; option++) {
            command(p, "scoreboard players set #o_parry sc_var " + option);
            command(p, "function sc:cfg/calc");
            int playerThreshold = (4 + option * 2) * 50 - 100;
            for (int owner : new int[]{2, 0}) {
                command(p, "scoreboard players set @e[tag=sc_test_parry_setting] sc_team " + owner);
                command(p, "scoreboard players set @e[tag=sc_test_parry_setting] sc_swap_cd 0");
                ball.setDeltaMovement(-0.1, 0, 0); // Incoming ball contributes 100 thousandths/tick.
                String attempt = "execute as @e[tag=sc_test_parry_setting] at @s run function sc:cube/try_charge_hit";
                command(p, "scoreboard players set #pvx sc_var " + playerThreshold);
                command(p, "scoreboard players set @e[tag=sc_test_parry_setting] sc_fuse 10");
                command(p, attempt);
                h.assertTrue(score(ball, "sc_team") == owner, "parry changed a locked colour");
                command(p, "scoreboard players set @e[tag=sc_test_parry_setting] sc_fuse 11");
                command(p, "scoreboard players set @e[tag=sc_test_parry_setting] sc_swap_cd 1");
                command(p, attempt);
                h.assertTrue(score(ball, "sc_team") == owner, "parry ignored protection cooldown");
                command(p, "scoreboard players set @e[tag=sc_test_parry_setting] sc_swap_cd 0");
                command(p, "scoreboard players set #pvx sc_var " + (playerThreshold - 1));
                command(p, attempt);
                h.assertTrue(score(ball, "sc_team") == owner, "parry below threshold");
                command(p, "scoreboard players set #pvx sc_var " + playerThreshold);
                command(p, attempt);
                h.assertTrue(score(ball, "sc_team") == 1 && score(ball, "sc_fuse") == 11 && score(ball, "sc_heavy") == 1
                        && score(ball, "sc_width") == 3 && score(ball, "sc_swap_cd") == 6, "incorrect capture at threshold");
            }
        }
        ball.discard();
        command(p, "function sc:cfg/defaults");
    }

    static void checkJab(GameTestHelper h, ServerPlayer p, ItemStack spear) {
        p.getInventory().setSelectedSlot(0);
        p.snapTo(0.5, 65, 0.5, 0, 0); // Level gaze along +Z, grazing the upper edge of both airborne cubes.
        p.setYHeadRot(0);
        var near = whiteBall(p, "sc_test_near", "0.95 65.75 3.0");
        var far = whiteBall(p, "sc_test_far", "0.95 65.75 4.65");
        var chain = whiteBall(p, "sc_test_chain", "0.5 65.75 3.75");
        command(p, "execute as @e[tag=sc_test_chain] at @s run function sc:cube/chain_other");
        var miss = whiteBall(p, "sc_test_miss", "1.65 65 1.25");
        var jab = spear.get(DataComponents.PIERCING_WEAPON);
        jab.attack(p, EquipmentSlot.MAINHAND);
        h.assertTrue(near.getDeltaMovement().lengthSqr() > 0 && far.getDeltaMovement().lengthSqr() > 0,
                "native jab failed to launch both targets: " + near.getDeltaMovement() + ", " + far.getDeltaMovement());
        h.assertTrue(score(near, "sc_team") == 1 && score(far, "sc_team") == 1, "physically hit white ball left unpainted");
        h.assertTrue(score(near, "sc_fuse") == 100 && score(far, "sc_width") == 1, "white jab did not arm a narrow trail");
        h.assertTrue(score(miss, "sc_team") == 0 && score(miss, "sc_fuse") == -1, "nearby off-axis ball was painted");
        h.assertTrue(score(chain, "sc_team") == 0 && score(chain, "sc_fuse") == 30 && score(chain, "sc_vz") > 0,
                "jab must deflect a chain-primed white ball without claiming or extending it");

        command(p, "scoreboard players set @e[tag=sc_test_near] sc_fuse 40");
        command(p, "scoreboard players set @e[tag=sc_test_far] sc_team 2");
        command(p, "team join blue @e[tag=sc_test_far]");
        command(p, "scoreboard players set @e[tag=sc_test_far] sc_fuse 35");
        jab.attack(p, EquipmentSlot.MAINHAND);
        h.assertTrue(score(near, "sc_fuse") == 60, "one friendly jab must extend exactly once");
        h.assertTrue(score(far, "sc_team") == 2 && score(far, "sc_fuse") == 35, "jab stole or extended an enemy ball");

        command(p, "setblock 0 66 1 stone");
        jab.attack(p, EquipmentSlot.MAINHAND);
        h.assertTrue(score(near, "sc_fuse") == 60 && score(miss, "sc_team") == 0, "blocked jab or stale contact changed a ball");
        command(p, "setblock 0 66 1 air");
    }

    static void useTicks(ServerPlayer p, int ticks) {
        for (int i = 0; i < ticks; i++) {
            command(p, "scoreboard players add #gt sc_var 1");
            command(p, "function sc:player/stamina_tick");
            p.doTick();
        }
    }

    static void checkGravity(GameTestHelper h, ServerPlayer p) {
        p.getInventory().setSelectedSlot(1);
        p.snapTo(0.5, 65, 0.5, 0, 0);
        p.setYHeadRot(0);
        p.setDeltaMovement(0, 0, 0);
        var gold = p.getMainHandItem();
        var food = p.getFoodData();
        food.setFoodLevel(8);
        food.setSaturation(0);
        command(p, "effect clear @s");
        var white = whiteBall(p, "sc_test_pull_white", "-0.5 65 2.5");
        var red = whiteBall(p, "sc_test_pull_red", "0.5 65 4.5");
        var blue = whiteBall(p, "sc_test_pull_blue", "-1.5 65 1.5");
        var edge = whiteBall(p, "sc_test_pull_edge", "4.5 65 2.5");
        var outside = whiteBall(p, "sc_test_pull_far", "4.51 65 2.5");
        owner(p, "sc_test_pull_red", 1, 37);
        owner(p, "sc_test_pull_blue", 2, 8);
        command(p, "tag @e[tag=sc_test_pull_blue] add sc_impact");
        command(p, "tag @e[tag=sc_test_pull_blue] add sc_locked");
        red.setDeltaMovement(0.5, 0.07, 0);
        blue.setDeltaMovement(0, 0, 0.65);
        gold.use(p.level(), p, InteractionHand.MAIN_HAND);
        h.assertTrue(p.isUsingItem(), "gold right-click did not start native spear use");
        useTicks(p, 5);
        h.assertTrue(white.getDeltaMovement().lengthSqr() == 0 && red.getDeltaMovement().z == 0, "gravity started during wind-up");
        useTicks(p, 1);
        h.assertTrue(white.getDeltaMovement().x > 0 && red.getDeltaMovement().z < 0 && blue.getDeltaMovement().x > 0,
                "held gold did not steer all colours: " + white.getDeltaMovement() + " / " + red.getDeltaMovement() + " / " + blue.getDeltaMovement());
        h.assertTrue(Math.abs(red.getDeltaMovement().horizontalDistance() - 0.5) < 0.002 && red.getDeltaMovement().y == 0.07,
                "gravity replaced the original momentum or pulled vertically");
        h.assertTrue(edge.getDeltaMovement().x < 0 && outside.getDeltaMovement().lengthSqr() == 0, "4-block focus radius boundary failed");
        h.assertTrue(score(white, "sc_fuse") == -1 && score(white, "sc_team") == 0 && score(red, "sc_fuse") == 37
                && score(red, "sc_team") == 1 && score(blue, "sc_team") == 2 && score(blue, "sc_fuse") == 8
                && blue.entityTags().containsAll(java.util.Set.of("sc_impact", "sc_locked")), "pull changed ownership, fuse or impact mode");
        // Same player and same focus: wall between focus and ball excludes only that ball.
        command(p, "setblock 0 65 3 mud_bricks");
        var rv = red.getDeltaMovement();
        var bv = blue.getDeltaMovement();
        useTicks(p, 1);
        h.assertTrue(red.getDeltaMovement().equals(rv) && !blue.getDeltaMovement().equals(bv), "wall did not selectively block attraction");
        command(p, "setblock 0 65 3 air");
        command(p, "setblock 0 65 1 stone_bricks");
        bv = blue.getDeltaMovement();
        useTicks(p, 1);
        h.assertTrue(blue.getDeltaMovement().equals(bv), "caster projected a field through a wall");
        command(p, "setblock 0 65 1 air");
        p.releaseUsingItem();
        rv = red.getDeltaMovement();
        useTicks(p, 3);
        h.assertTrue(red.getDeltaMovement().equals(rv), "releasing gold continued applying force or set release velocity");
        // Accumulated 3 active ticks before release; a new hold must wind up again.
        gold.use(p.level(), p, InteractionHand.MAIN_HAND);
        useTicks(p, 5);
        h.assertTrue(red.getDeltaMovement().equals(rv), "re-press skipped wind-up");
        useTicks(p, 20);
        h.assertTrue(food.getFoodLevel() == 8, "holding gravity consumed food");
        food.setFoodLevel(6);
        red.setDeltaMovement(0.5, 0.07, 0);
        rv = red.getDeltaMovement();
        useTicks(p, 1);
        h.assertTrue(!red.getDeltaMovement().equals(rv), "low-food player could not apply gravity");
        h.assertTrue(food.getFoodLevel() == 6, "low-food gravity consumed food");
        p.getInventory().setSelectedSlot(0);
        rv = red.getDeltaMovement();
        food.setFoodLevel(20);
        useTicks(p, 8);
        h.assertTrue(!p.isUsingItem() && red.getDeltaMovement().equals(rv), "switching away from gold left the field active");
        for (var b : java.util.List.of(white, red, blue, edge, outside)) b.discard();
    }

    static void run(GameTestHelper h) {
        // The convenience in-level mock always reports CREATIVE to Lunge's food predicate.
        var p = (ServerPlayer) h.makeMockServerPlayer(GameType.ADVENTURE);
        var connection = new Connection(PacketFlow.SERVERBOUND);
        new EmbeddedChannel(connection);
        h.getLevel().getServer().getPlayerList().placeNewPlayer(connection, p, CommonListenerCookie.createInitial(p.getGameProfile(), false));
        // A real client acknowledges the level load; until then the server ignores all damage.
        p.connection.handleAcceptPlayerLoad(new net.minecraft.network.protocol.game.ServerboundPlayerLoadedPacket());
        p.setGameMode(GameType.ADVENTURE);
        p.snapTo(0.5, 70.0, -16.5, 0, 20);
        h.getLevel().getChunkSource().tick(() -> true, true);
        command(p, "function sc_test:rules");
        h.assertTrue(matchScore(p, "#errors") == 0, "sc_test:rules assertions failed: errors=" + matchScore(p, "#errors"));
        command(p, "function sc:arena/reset_round");
        p.getFoodData().setFoodLevel(1);
        p.getInventory().setItem(4, new ItemStack(Items.EMERALD, 3));
        command(p, "team join red @s");
        command(p, "function sc:game/start");
        var spear = p.getInventory().getItem(0);
        h.assertTrue(spear.is(Items.DIAMOND_SPEAR), "missing match spear");
        for (int tick : new int[]{1, 5, 10, 40, 100, 160, 200}) {
            var actual = new PoseStack();
            var vanilla = new PoseStack();
            SpearAnimations.firstPersonUse(0, actual, tick, HumanoidArm.RIGHT, spear);
            SpearAnimations.firstPersonUse(0, vanilla, tick, HumanoidArm.RIGHT, new ItemStack(Items.DIAMOND_SPEAR));
            h.assertTrue(actual.last().pose().equals(vanilla.last().pose(), 0.00001f), "wrong diamond spear pose at " + tick);
        }
        var kinetic = spear.get(DataComponents.KINETIC_WEAPON);
        for (var condition : java.util.List.of(kinetic.damageConditions(), kinetic.knockbackConditions(), kinetic.dismountConditions())) {
            h.assertTrue(!condition.orElseThrow().test(5, 1, 1, 1), "native impact bypassed the datapack parry");
        }

        var food = p.getFoodData();
        p.getInventory().setSelectedSlot(1);
        for (int i = 0; i < 60; i++) p.doTick();
        h.assertTrue(food.getFoodLevel() == 20 && food.getSaturationLevel() == 0, "round start: hidden saturation still present");
        var dash = p.getMainHandItem().get(DataComponents.PIERCING_WEAPON);
        p.setDeltaMovement(0, 0, 0);
        dash.attack(p, EquipmentSlot.MAINHAND);
        h.assertTrue(p.getDeltaMovement().horizontalDistanceSqr() > 0.1, "full-food jab did not lunge");
        for (int i = 0; i < 3; i++) p.doTick();
        h.assertTrue(food.getFoodLevel() == 18, "Lunge II did not consume one visible drumstick: " + food.getFoodLevel());
        for (int i = 0; i < 50; i++) {
            command(p, "function sc:player/stamina_tick");
            p.doTick();
            h.assertTrue(food.getFoodLevel() == (i == 49 ? 19 : 18), "wrong food regeneration on tick " + (i + 1));
        }
        for (int i = 0; i < 3; i++) p.doTick();
        h.assertTrue(food.getSaturationLevel() == 0, "regeneration gave a hidden stamina buffer");
        food.setFoodLevel(6);
        p.setDeltaMovement(0, 0, 0);
        dash.attack(p, EquipmentSlot.MAINHAND);
        h.assertTrue(p.getDeltaMovement().horizontalDistanceSqr() < 0.00001, "low-food jab triggered Lunge II");
        for (int i = 0; i < 3; i++) p.doTick();
        h.assertTrue(food.getFoodLevel() == 6, "low-food jab: expected 6 food, got " + food.getFoodLevel() + ", health=" + p.getHealth());
        command(p, "scoreboard players set #state sc_var 2");
        checkFloorGrace(h, p);
        checkServe(h, p);
        checkParrySetting(h, p);
        checkGravity(h, p);
        checkDashShot(h, p);
        checkJab(h, p, spear);
        command(p, "function sc:game/check_alive");
        h.assertTrue(!p.entityTags().contains("sc_ingame") && p.getY() == 70, "match ended without immediately returning player");
        var restored = p.getInventory().getItem(4);
        h.assertTrue(restored.is(Items.EMERALD) && restored.getCount() == 3, "match did not restore the original inventory");
        checkEndless(h, p);
        System.out.println("SC_PLAYER_OK");
        h.succeed();
    }
}
