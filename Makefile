SRCS= main.asm mainloop.asm exceptions.asm renderer.asm level.asm \
opengl.asm graphics.asm camera.asm EntList.asm rendererUtils.asm \
terrainRenderer.asm entityRenderer.asm EntMgr.asm \
Entity.asm EntityPlayer.asm EntityBullet.asm EntityEnemy1.asm \
Timer.asm RayCaster.asm Game.asm Gui.asm

LIBS=SDL GL glfw IL ILU ILUT
NASMFLAGS=-f elf32 -g -F dwarf -i "include/"
CFLAGS=-g -m32

all: game

game: $(addprefix obj/,$(addsuffix .o,$(SRCS)))
	gcc $(CFLAGS) -o $@ $^ $(addprefix -l,$(LIBS))



obj:
	mkdir obj

dep:
	mkdir dep

obj/%.asm.o: src/%.asm obj dep
	nasm -MP -MD dep/$*.asm.dep $(NASMFLAGS) -o $@  $< 

clean:
	rm dep/*.dep obj/*.o ./game

-include $(addprefix dep/,$(addsuffix .dep	,$(SOURCES)))
